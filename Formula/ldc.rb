class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.22.0/ldc-1.22.0-src.tar.gz"
  sha256 "866becac61fb225b0d55847fb5f206ff042d6a3ff63b671a474aa8b6a93d8988"
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "122d9a37cccbd671d223a2ce683ad141489633d2f11fa8f662635f6ba4a49027" => :catalina
    sha256 "67f9bdd412e9ee9e6864f52ae5b52358a01b93de359fe8aad4b9d7bed73a572a" => :mojave
    sha256 "7945dba30bfac0ced442b69a46a477593ee04e3b3f28cc6fdb56b94f58e94706" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "ldc-bootstrap" do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.22.0/ldc2-1.22.0-osx-x86_64.tar.xz"
    version "1.22.0"
    sha256 "05e3a6048aadcfc2ba8f81b236e6da9c1f36c538a0f4e5e6ae22667328c7e8f2"
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      ]

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
