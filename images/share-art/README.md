# bioBakery tool tiles

Tiles are generated from `tools.csv` + `art/`. Edit those, then run:

    python3 make_tiles.py            # both versions
    python3 make_tiles.py --variant desc|name

Needs: `pip install playwright pillow numpy scipy && playwright install chromium`

- **tools.csv** — `group, tool, description, art, featured` (featured = `yes` draws the star). Row order = page order.
- **art/** — PNG/JPG/PSD. Stray specks and empty margins are trimmed automatically. Blank `art` cell → `art/Bakey.png` (or a dashed placeholder box if that file is missing).
- Group colours, text colour, font sizes: top of `make_tiles.py`.
- Description size is chosen automatically: the largest single size at which *every* description fits on two lines.

Outputs in `output/`: one 7×5 in page per tile (`tiles_with_descriptions.pdf`, `tiles_names_only.pdf`), 300-dpi PNGs in `output/png/…`, and contact sheets for quick review.
