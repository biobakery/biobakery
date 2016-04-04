class Kneaddata < Formula
  desc "Removes human contaminants from metagenomic sequencing data"
  homepage "https://bitbucket.org/biobakery/kneaddata"
  url "https://bitbucket.org/biobakery/kneaddata/get/0.5.1.tgz"
  version "0.5.1"
  sha256 "9b5bee562406d53283ac811725d396eb08f2b0957f9b4a45940cb97d4dec4ec5"
  
  depends_on "bowtie2"
  depends_on "fastqc"
  depends_on "trf"
  depends_on "samtools"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    system "#{bin}/kneaddata", "--version"
  end
end
