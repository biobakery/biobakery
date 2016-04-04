class Picrust < Formula
  desc "Predict metagenome functional content from 16S data"
  homepage "https://picrust.github.io/picrust/"
  url "https://github.com/picrust/picrust/releases/download/1.0.0/picrust-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "3b10edc9db4f377e1d6cc27099359a4a28ba6d5e851f5df7379f096e0ffa49d6"
  
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "homebrew/python/numpy"

  resource "biom-format" do
    url "https://pypi.python.org/packages/source/b/biom-format/biom-format-1.3.1.tar.gz"
    sha256 "03e750728dc2625997aa62043adaf03643801ef34c1764213303e926766f4cef"
  end

  resource "pyqi" do
    url "https://pypi.python.org/packages/source/p/pyqi/pyqi-0.3.2.tar.gz"
    sha256 "8f1711835779704e085e62194833fed9ac2985e398b4ceac6faf6c7f40f5d15f"
  end

  resource "cogent" do
    url "https://github.com/pycogent/pycogent/archive/1.5.3-release.tar.gz"
    sha256 "4e19325cd1951382dc71582eb49f44c5a19eb128e3540e29dc28e080091e49cd"
  end

  resource "precalc_16s" do
    url "ftp://ftp.microbio.me/pub/picrust-references/picrust-1.0.0/16S_13_5_precalculated.tab.gz"
    sha256 "ae9c25bda0bdc52db054f311e765daa1bcfc33b35261cc57b379938ef9feff3f"
  end

  resource "precalc_ko" do
    url "ftp://ftp.microbio.me/pub/picrust-references/picrust-1.0.0/ko_13_5_precalculated.tab.gz"
    sha256 "26371c9eaf8decdfea0a6b2ae887a13789b762dc15da60629f5efda564750ce6"
  end
  
  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[biom-format pyqi].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    resource("cogent").stage do
      ENV["CFLAGS"] += " -I./include -I" + ENV["HOMEBREW_PREFIX"]+"/lib/python2.7/site-packages/numpy/core/include "
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end
    
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    prefix.install Dir["*"]
    bin.install Dir["#{prefix}/scripts/*"]
    bin.env_script_all_files(prefix/"scripts", :PYTHONPATH => ENV["PYTHONPATH"])

    mkdir prefix/"picrust/data/"
    %w[precalc_16s precalc_ko].each do |name|
      fn = resource(name).fetch
      resource(name).verify_download_integrity(fn)
      mv fn, prefix/"picrust/data/16S_13_5_precalculated.tab.gz"
    end

  end

  test do
    system "#{bin}/print_picrust_config.py"
  end
end
