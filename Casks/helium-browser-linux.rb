cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"
  os linux: "linux"

  on_linux do
    version "0.14.9.1"
    sha256 arm64_linux:  "a9500aae092b3d0f0e56ac0bccb840bbd355bb67512c509ed52adb1f6cee07fa",
           x86_64_linux: "066617df12a9cd5b32c51c66ca93295d19e9ebe679c0b71a118f1a11837e673d"
  end

  url "https://github.com/imputnet/helium-linux/releases/download/#{version}/helium-#{version}-#{arch}_linux.tar.xz",
      verified: "github.com/imputnet/helium-linux/"
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

  zap trash: [
    "~/.cache/net.imput.helium",
    "~/.config/net.imput.helium",
  ]
end
