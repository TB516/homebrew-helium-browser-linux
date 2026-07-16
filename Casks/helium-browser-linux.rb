cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"
  os linux: "linux"

  on_linux do
    version "0.14.6.1"
    sha256 arm64_linux:  "dd4566a1dc3d6f7572de1cc034bf5764a4c5aaaf71785f7dfece83a501b58a19",
           x86_64_linux: "2717a5b827bac7d785d61a783d1208e52d1d97849c556f681c96a835b571bfb0"
  end

  url "https://github.com/imputnet/helium-linux/releases/download/#{version}/helium-#{version}-#{arch}_linux.tar.xz"
  name "Helium"
  desc "Private, fast, and honest web browser"
  homepage "https://helium.computer/"

  livecheck do
    url "https://github.com/imputnet/helium-linux/releases"
    strategy :github_latest
  end

  binary "helium-#{version}-#{arch}_linux/helium-wrapper", target: "helium"
  artifact "helium-#{version}-#{arch}_linux/helium.desktop",
           target: "#{ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"}/applications/helium.desktop"
  artifact "helium-#{version}-#{arch}_linux/product_logo_256.png",
           target: "#{ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"}/icons/hicolor/256x256/apps/helium.png"

  preflight do
    xdg_data_home = ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"

    FileUtils.mkdir_p "#{xdg_data_home}/applications"
    FileUtils.mkdir_p "#{xdg_data_home}/icons/hicolor/256x256/apps"

    desktop_file = "#{staged_path}/helium-#{version}-#{arch}_linux/helium.desktop"
    contents = File.read(desktop_file)

    brew_exec = "#{HOMEBREW_PREFIX}/bin/helium"

    contents.gsub!(/^Exec=helium(.*)$/, "Exec=#{brew_exec}\\1")
    contents.gsub!(/^StartupNotify=true$/, "StartupNotify=false")

    File.write(desktop_file, contents)
  end

  zap delete: [
    "~/.cache/net.imput.helium",
    "~/.config/net.imput.helium",
  ]
end
