cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"

  version "0.16.4.1"
  sha256 arm64_linux:  "397e9b73d9805fb5aa1fd057c19efdb14c451dfb6ee5bfa53e630365d93dae0e",
         x86_64_linux: "683edba74ab8f6ae0ac7272a3c27f9ef945690629e1525370887b17815cedcbe"

  url "https://github.com/imputnet/helium-linux/releases/download/#{version}/helium-#{version}-#{arch}_linux.tar.xz"
  name "Helium"
  desc "Private, fast, and honest web browser"
  homepage "https://helium.computer/"

  livecheck do
    url "https://github.com/imputnet/helium-linux/releases"
    strategy :github_latest
  end

  depends_on :linux

  binary "helium-#{version}-#{arch}_linux/helium-wrapper", target: "helium"
  artifact "helium-#{version}-#{arch}_linux/helium.desktop",
           target: "#{ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"}/applications/helium.desktop"
  artifact "helium-#{version}-#{arch}_linux/product_logo_256.png",
           target: "#{ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"}/icons/hicolor/256x256/apps/helium.png"

  xdg_data_home = ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"
  desktop_file = "helium-#{version}-#{arch}_linux/helium.desktop"

  preflight_steps do
    mkdir_p "#{xdg_data_home}/applications"
    mkdir_p "#{xdg_data_home}/icons/hicolor/256x256/apps"

    inreplace desktop_file, /^Exec=helium(.*)$/, "Exec=#{HOMEBREW_PREFIX}/bin/helium\\1"
    inreplace desktop_file, /^StartupNotify=true$/, "StartupNotify=false"
  end

  zap trash: [
    "~/.cache/net.imput.helium",
    "~/.config/net.imput.helium",
  ]
end
