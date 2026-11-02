#!/usr/bin/env python3
"""Generate bioBakery tool tiles from tools.csv + art/.

    python3 make_tiles.py                  # both variants
    python3 make_tiles.py --variant desc   # only tiles with descriptions
    python3 make_tiles.py --variant name   # only name + art tiles

tools.csv columns:
    group        - must match a key in GROUP_COLORS below
    tool         - tool name shown on the tile
    description  - one sentence; auto-sized to fit on two lines
    art          - filename in art/ (blank -> Bakey placeholder)
    featured     - "yes" draws the star in the top-left corner

Outputs (in output/):
    tiles_with_descriptions.pdf / tiles_names_only.pdf   (one 7x5in page per tile, vector text)
    png/<variant>/<NN>_<tool>.png                         (300 dpi)
    contact_sheet_<variant>.png                           (quick review grid)
"""
import argparse
import base64
import csv
import html
import mimetypes
import re
import sys
from pathlib import Path

from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parent
ART_DIR = ROOT / "art"
OUT_DIR = ROOT / "output"
FONT = ROOT / "fonts" / "Montserrat-VariableFont_wght.ttf"

# ---- design settings ------------------------------------------------------
GROUP_COLORS = {
    "Microbial Community Profiling Tools": "#b8ccea",
    "Analysis/Statistics Tools": "#e9b1b4",
    "Infrastructure/Utilities": "#e9caa9",
}
TEXT_COLOR = "#4f4f52"
PLACEHOLDER_ART = "Bakey.png"  # used when a tool's art cell is blank / file missing
TILE_W, TILE_H = 672, 480       # CSS px  (= 7in x 5in, same as the Canva template)
PNG_DPI = 300
SPECK_FRACTION = 0.002          # art blobs smaller than 0.2% of the drawing are treated as stray specks

VARIANTS = {
    # name: (with description?, name max px, art takes the rest)
    "desc": dict(label="tiles_with_descriptions", show_desc=True, name_max=74),
    "name": dict(label="tiles_names_only", show_desc=False, name_max=88),
}
# ---------------------------------------------------------------------------

STAR_SVG = (
    '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 1.8l3.1 6.6 7.2.9-5.3 5 '
    '1.4 7.1L12 17.9l-6.4 3.5L7 14.3l-5.3-5 7.2-.9z"/></svg>'
)


def clean_art(path: Path) -> str:
    """Open PNG/JPG/PSD art, drop tiny stray specks, trim to content, return a PNG data URI."""
    import io
    import numpy as np
    from PIL import Image
    from scipy import ndimage
    im = Image.open(path).convert("RGBA")
    a = np.array(im)
    alpha = a[..., 3]
    if alpha.min() == 255:  # no transparency (e.g. a JPG): use as-is
        return data_uri_bytes(path.read_bytes(), mimetypes.guess_type(path.name)[0] or "image/png")
    labels, n = ndimage.label(alpha > 40)
    if n:
        sizes = ndimage.sum(np.ones_like(labels), labels, range(1, n + 1))
        keep = np.isin(labels, 1 + np.flatnonzero(sizes >= SPECK_FRACTION * sizes.sum()))
        # keep soft anti-aliased edges next to kept shapes, clear everything else
        keep = ndimage.binary_dilation(keep, iterations=3)
        a[..., 3] = np.where(keep, alpha, 0)
    im = Image.fromarray(a)
    im = im.crop(im.getchannel("A").getbbox())
    buf = io.BytesIO()
    im.save(buf, "PNG")
    return data_uri_bytes(buf.getvalue(), "image/png")


def data_uri_bytes(b: bytes, mime: str) -> str:
    return f"data:{mime};base64,{base64.b64encode(b).decode()}"


def data_uri(path: Path) -> str:
    mime = mimetypes.guess_type(path.name)[0] or "application/octet-stream"
    return f"data:{mime};base64,{base64.b64encode(path.read_bytes()).decode()}"


def load_rows():
    rows = list(csv.DictReader(open(ROOT / "tools.csv", encoding="utf-8-sig")))
    problems = []
    for r in rows:
        r = {k: (v or "").strip() for k, v in r.items()}
        if r["group"] not in GROUP_COLORS:
            problems.append(f"{r['tool']}: unknown group '{r['group']}' (add it to GROUP_COLORS)")
    if problems:
        sys.exit("\n".join(problems))
    return [{k: (v or "").strip() for k, v in r.items()} for r in rows]


def art_html(row, warnings):
    path = ART_DIR / row["art"] if row["art"] else None
    if not path or not path.is_file():
        if row["art"]:
            warnings.append(f"{row['tool']}: art file '{row['art']}' not found -> placeholder")
        else:
            warnings.append(f"{row['tool']}: no art listed -> placeholder")
        path = ART_DIR / PLACEHOLDER_ART
        if not path.is_file():
            return '<div class="art placeholder"><span>Bakey<br>placeholder</span></div>'
    return f'<div class="art"><img src="{clean_art(path)}"></div>'


def build_html(rows, show_desc, name_max, warnings):
    tiles = []
    for r in rows:
        star = f'<div class="star">{STAR_SVG}</div>' if r["featured"].lower() in ("yes", "y", "true", "1", "x") else ""
        desc = f'<div class="desc">{html.escape(r["description"])}</div>' if show_desc else ""
        tiles.append(
            f'<section class="tile" style="background:{GROUP_COLORS[r["group"]]}">{star}'
            f'<div class="name">{html.escape(r["tool"])}</div>{desc}{art_html(r, warnings)}</section>'
        )
    return f"""<!doctype html><html><head><meta charset="utf-8"><style>
@font-face {{ font-family: Montserrat; src: url('{data_uri(FONT)}') format('truetype'); font-weight: 100 900; }}
@page {{ size: {TILE_W}px {TILE_H}px; margin: 0; }}
* {{ box-sizing: border-box; margin: 0; padding: 0; }}
html, body {{ background: white; }}
body {{ font-family: Montserrat; color: {TEXT_COLOR}; -webkit-print-color-adjust: exact; print-color-adjust: exact; }}
.tile {{ position: relative; width: {TILE_W}px; height: {TILE_H}px; overflow: hidden; break-after: page;
        display: flex; flex-direction: column; align-items: center; padding: 22px 36px 26px; }}
.star {{ position: absolute; left: 18px; top: 16px; width: 50px; height: 50px; color: {TEXT_COLOR}; }}
.name {{ font-weight: 500; font-size: {name_max}px; line-height: 1.1; white-space: nowrap; text-align: center;
        max-width: 470px; letter-spacing: .01em; }}
.desc {{ font-weight: 500; text-align: center; line-height: 1.25; width: 100%; margin-top: 6px; text-wrap: balance; }}
.art {{ flex: 1 1 auto; min-height: 0; width: 100%; display: flex; align-items: center; justify-content: center;
       margin-top: 14px; }}
.art img {{ max-width: 100%; max-height: 100%; object-fit: contain; }}
.placeholder span {{ border: 3px dashed {TEXT_COLOR}; border-radius: 16px; padding: 60px 80px; font-size: 30px;
                    text-align: center; opacity: .6; }}
</style></head><body>{''.join(tiles)}
<script>
document.fonts.ready.then(() => {{
  // 1) shrink any tool name that is wider than its box
  document.querySelectorAll('.name').forEach(n => {{
    let s = {name_max};
    while (n.scrollWidth > n.clientWidth && s > 20) n.style.fontSize = (--s) + 'px';
  }});
  // 2) ONE description size for every tile: the largest that keeps all of them on <= 2 lines
  const ds = [...document.querySelectorAll('.desc')];
  if (ds.length) {{
    const fits = s => ds.every(d => {{ d.style.fontSize = s + 'px'; return d.getBoundingClientRect().height <= 2 * s * 1.25 + 1; }});
    let s = 40; while (s > 8 && !fits(s)) s -= 0.5;
    fits(s); document.body.dataset.descSize = s;
  }}
  document.body.dataset.ready = '1';
}});
</script></body></html>"""


def safe(name):
    return re.sub(r"[^A-Za-z0-9]+", "_", name).strip("_")


def render(variant, rows, browser):
    cfg = VARIANTS[variant]
    warnings = []
    page_html = build_html(rows, cfg["show_desc"], cfg["name_max"], warnings)
    png_dir = OUT_DIR / "png" / cfg["label"]
    png_dir.mkdir(parents=True, exist_ok=True)
    for old in png_dir.glob("*.png"):
        old.unlink()

    page = browser.new_page(viewport={"width": TILE_W, "height": TILE_H}, device_scale_factor=PNG_DPI / 96)
    page.set_content(page_html)
    page.wait_for_selector("body[data-ready='1']")
    page.pdf(path=str(OUT_DIR / f"{cfg['label']}.pdf"), width=f"{TILE_W}px", height=f"{TILE_H}px", print_background=True)
    for i, (tile, r) in enumerate(zip(page.query_selector_all(".tile"), rows), 1):
        tile.screenshot(path=str(png_dir / f"{i:02d}_{safe(r['tool'])}.png"))
    desc_size = page.evaluate("document.body.dataset.descSize")
    page.close()

    contact_sheet(sorted(png_dir.glob("*.png")), OUT_DIR / f"contact_sheet_{cfg['label']}.png")
    print(f"[{variant}] {len(rows)} tiles -> output/{cfg['label']}.pdf, output/png/{cfg['label']}/"
          + (f"  (description font {desc_size}px = {float(desc_size) * 0.75:g}pt)" if desc_size else ""))
    for w in dict.fromkeys(warnings):
        print("   warning:", w)


def contact_sheet(files, out, cols=5, thumb_w=420):
    from PIL import Image
    ims = [Image.open(f) for f in files]
    th = round(thumb_w * TILE_H / TILE_W)
    sheet = Image.new("RGB", (cols * (thumb_w + 8) + 8, ((len(ims) + cols - 1) // cols) * (th + 8) + 8), "white")
    for i, im in enumerate(ims):
        sheet.paste(im.convert("RGB").resize((thumb_w, th), Image.LANCZOS), (8 + (i % cols) * (thumb_w + 8), 8 + (i // cols) * (th + 8)))
    sheet.save(out)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--variant", choices=[*VARIANTS, "both"], default="both")
    args = ap.parse_args()
    rows = load_rows()
    OUT_DIR.mkdir(exist_ok=True)
    with sync_playwright() as p:
        browser = p.chromium.launch()
        for v in (VARIANTS if args.variant == "both" else [args.variant]):
            render(v, rows, browser)
        browser.close()


if __name__ == "__main__":
    main()
