class NtfyMacos < Formula
  desc "Native macOS CLI notifier and automation agent for ntfy"
  homepage "https://github.com/laurentftech/ntfy-macos"
  url "https://github.com/laurentftech/ntfy-macos/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "7a0f3847948629dd2c780fac614017f900118bc4d9b0847967f16db80ee5a05c"
  license "Apache-2.0"
  version "v0.1.1"
  head "https://github.com/laurentftech/ntfy-macos.git", branch: "main"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    
    app_name = "ntfy-macos"
    app_bundle = "#{app_name}.app"
    build_dir = ".build/release"
    
    mkdir_p "#{build_dir}/#{app_bundle}/Contents/MacOS"
    mkdir_p "#{build_dir}/#{app_bundle}/Contents/Resources"
    
    cp "#{build_dir}/#{app_name}", "#{build_dir}/#{app_bundle}/Contents/MacOS/"
    cp "Resources/Info.plist", "#{build_dir}/#{app_bundle}/Contents/"
    cp "Resources/ntfy-macos.icns", "#{build_dir}/#{app_bundle}/Contents/Resources/"
    
    system "codesign", "--force", "--deep", "--sign", "-", "#{build_dir}/#{app_bundle}"
    
    prefix.install "#{build_dir}/#{app_bundle}"
    bin.install_symlink prefix/"#{app_bundle}/Contents/MacOS/#{app_name}"
  end

  service do
    run [opt_bin/"ntfy-macos", "serve"]
    keep_alive true
    log_path var/"log/ntfy-macos/stdout.log"
    error_log_path var/"log/ntfy-macos/stderr.log"
  end

  test do
    system bin/"ntfy-macos", "help"
  end
end
