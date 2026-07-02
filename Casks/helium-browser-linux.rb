cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"
  os linux: "linux"

  on_linux do
    version "0.14.2.1"
    sha256 arm64_linux:  "b1006a1c197837accafccdf53ae56a8b3f95355b4fc422469942854ac25191c9",
           x86_64_linux: "4f1ed7a73c8bc5df8ac883eeccc7a59019f289a2cf6aee7d9e6be31f80bfb9b0"
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
