class NtfyMacos < Formula
  desc "Native macOS CLI notifier and automation agent for ntfy"
  homepage "https://github.com/laurentftech/ntfy-macos"
  url "https://github.com/laurentftech/ntfy-macos/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "1c50ef989b4d1615773a2bda42bf6f9fba5e8e8726469b1e698c31e64bb0260d"
  license "MIT"
  version "v0.1.3"
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
    run [opt_prefix/"ntfy-macos.app/Contents/MacOS/ntfy-macos", "serve"]
    keep_alive crashed: true
    log_path var/"log/ntfy-macos/stdout.log"
    error_log_path var/"log/ntfy-macos/stderr.log"
  end

  def caveats
    <<~EOS
      To add ntfy-macos to Launchpad:
        sudo ln -sf #{opt_prefix}/ntfy-macos.app /Applications/

      To enable Start at Login, launch the app and check the option in the menu bar.
    EOS
  end

  test do
    system bin/"ntfy-macos", "help"
  end
end
