class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libupnp-1.10.1/libupnp-1.10.1.tar.bz2"
  sha256 "b97dad43f5fbb1dad34384389ab038823862348e9e5f6d649d845d512165ed92"

  bottle do
    cellar :any
    sha256 "f1aef281c1909cd4c596cbed4275d12776aa3b6a4003aaa1e0038648218052b1" => :catalina
    sha256 "28cc0a51186e7a4a52709620ec37e923002a8537e1e2db5c2096fed4987731a7" => :mojave
    sha256 "cbca37b45cb652c73d4c5ae0ae087338bb4c606f5be4306c5d998c39c382bb4b" => :high_sierra
    sha256 "b870845572dd6d11ed90fedfb367bbd53066f6b9c90e522b97ce88ae53ccddfe" => :sierra
    sha256 "9b660881232e6ce94a375962c1df55f179f69335c7d11907b9a9c5dd81693360" => :el_capitan
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
