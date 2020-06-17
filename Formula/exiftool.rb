class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-12.00.tar.gz"
  sha256 "d0792cc94ab58a8b3d81b18ccdb8b43848c8fb901b5b7caecdcb68689c6c855a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0d05e8e55257a5132ffbc91bc4789d2828912f8df54ebbfbbe120d9c808d0c9" => :catalina
    sha256 "d0d05e8e55257a5132ffbc91bc4789d2828912f8df54ebbfbbe120d9c808d0c9" => :mojave
    sha256 "5c2ce26400d6ac9b6b678dfeb845dda3654d8a35be01c1270d8a0216bcb3dd56" => :high_sierra
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$1/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
