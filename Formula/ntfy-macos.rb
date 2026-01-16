class NtfyMacos < Formula
  desc "Native macOS CLI notifier and automation agent for ntfy"
  homepage "https://github.com/laurentftech/ntfy-macos"
  url "${SOURCE_URL}"
  sha256 "${SHA256}"
  license "Apache-2.0"
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
