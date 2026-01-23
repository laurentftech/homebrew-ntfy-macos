class NtfyMacos < Formula
  desc "Native macOS CLI notifier and automation agent for ntfy"
  homepage "https://github.com/laurentftech/ntfy-macos"
  url "https://github.com/laurentftech/ntfy-macos/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "c37072d31e72c807a642959318e89e6bbc404279f33ffddd9ed3a2c9dcb76a9c"
  license "MIT"
  version "v0.1.13"
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
    EOS
  end

  test do
    system bin/"ntfy-macos", "help"
  end
end
