class NtfyMacos < Formula
  desc "Native macOS CLI notifier and automation agent for ntfy"
  homepage "https://github.com/laurentftech/ntfy-macos"
  url "https://github.com/laurentftech/ntfy-macos/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "66544650cd2cdd588ac3bd302a1213725640c6fcab466a35120044aa888e9659"
  license "MIT"

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/ntfy-macos"
  end

  test do
    assert_match "ntfy-macos", shell_output("#{bin}/ntfy-macos help")
  end
end
