class NtfyMacos < Formula
  desc "Native macOS CLI notifier and automation agent for ntfy"
  homepage "https://github.com/laurentftech/ntfy-macos"
  url "https://github.com/laurentftech/ntfy-macos/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "81cea53ea0d8d3486dd150fbe65d4d1e747f28f217a739e31246751cb12d3f1a"
  license "MIT"
  head "https://github.com/laurentftech/ntfy-macos.git", branch: "main"

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "./build-app.sh"
    prefix.install ".build/release/ntfy-macos.app"
    bin.install_symlink prefix/"ntfy-macos.app/Contents/MacOS/ntfy-macos"
  end

  service do
    run [opt_bin/"ntfy-macos", "serve"]
    keep_alive true
    log_path var/"log/ntfy-macos/stdout.log"
    error_log_path var/"log/ntfy-macos/stderr.log"
  end

  test do
    system "#{bin}/ntfy-macos", "help"
  end
end
