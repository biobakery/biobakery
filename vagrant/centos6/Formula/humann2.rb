class Humann2 < Formula
  desc "Metagenomic functional profiling from raw WGS data"
  homepage "https://bitbucket.org/biobakery/humann2"
  url "https://bitbucket.org/biobakery/humann2/get/0.7.0.tgz"
  version "0.7.0"
  sha256 "634265b84d22485ea4aa1526dab4f317d2d1db1a073feab5c74b0f4263d9cad9"

  depends_on "metaphlan2"
  depends_on "diamond"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    system "#{bin}/humann2.py", "--version"
  end
end
