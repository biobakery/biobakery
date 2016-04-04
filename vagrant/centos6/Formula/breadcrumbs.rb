class Breadcrumbs < Formula
  desc "Miscellaneous Huttenhower Lab scripts"
  homepage "https://bitbucket.org/biobakery/breadcrumbs"
  url "https://bitbucket.org/biobakery/breadcrumbs/get/ed59079c2e5e.tar.gz"
  version "ed59079c2e5e"
  sha256 "9e7f2026b82372f59f2fa50e3ad578397edcc1423018fa386ab7454d01e5d1f3"
  
  depends_on "bowtie2"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "homebrew/python/numpy"
  depends_on "homebrew/python/scipy"
  depends_on "homebrew/python/matplotlib"
  depends_on "r" => [:optional, "without-x"]

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

  resource "blist" do
    url "https://pypi.python.org/packages/source/b/blist/blist-1.3.6.tar.gz"
    sha256 "3a12c450b001bdf895b30ae818d4d6d3f1552096b8c995f0fe0c74bef04d1fc3"
  end
  
  resource "vegan" do
    url "https://cran.r-project.org/src/contrib/vegan_2.3-4.tar.gz"
    sha256 "b9efeb684421670ac0cc8d5f8fe7c2b7e2d2ac92be5122d9703bd56a91f4efd9"
  end

  resource "r_optparse" do
    url "https://cran.r-project.org/src/contrib/optparse_1.3.2.tar.gz"
    sha256 "bca93c8646b731758f1cc888ee6c25e8c1ecf2364d7f556489bd879413d20abd"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[biom-format pyqi blist].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    resource("cogent").stage do
      ENV["CFLAGS"] += " -I./include -I" + ENV["HOMEBREW_PREFIX"]+"/lib/python2.7/site-packages/numpy/core/include "
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    args = Language::Python.setup_install_args(libexec)
    args[1].gsub! "setup.py", "actually_setup.py"
    system "python", *args
    prefix.install Dir["*"]
    bin.install Dir["#{prefix}/breadcrumbs/scripts/*"]
    bin.env_script_all_files(prefix/"scripts", :PYTHONPATH => ENV["PYTHONPATH"])

    if build.with? "r"
      ENV.prepend_create_path "R_LIBS", libexec/"vendor/R/library"
      system "R", "-q", "-e", "install.packages('devtools', lib='" + libexec/"vendor/R/library" + "', repos='http://cran.r-project.org')"
      ENV.prepend "LDFLAGS", "-L" + Formula["openssl"].opt_lib
      ENV.prepend "CPPFLAGS", "-I" + Formula["openssl"].opt_include
      %w[r_optparse vegan].each do |r|
        resource(r).stage do
          system "R", "-q", "-e", "library(devtools); install(pkg='.', lib='" + libexec/"vendor/R/library" + "')"
        end
      end
      
    end
  end

  test do
    system "#{bin}/scriptPcoa.py", "--help"
  end
end
