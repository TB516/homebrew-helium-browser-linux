cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"

  version "0.19.1.2"
  sha256 arm64_linux:  "8ed1de8ffe00f5439ada34de0f8f6d2a6a4914e05e1bc231e7bf176a983e7dd3",
         x86_64_linux: "d31ea7f64637934ac54438fb9a5cd2d3653e99dfa39bbe1f432b93b631aeafad"

  url "https://github.com/imputnet/helium-linux/releases/download/#{version}/helium-#{version}-#{arch}_linux.tar.xz"
  name "Helium"
  desc "Private, fast, and honest web browser"
  homepage "https://helium.computer/"

  livecheck do
    url "https://github.com/imputnet/helium-linux/releases"
    strategy :github_latest
  end

  depends_on :linux

  rename "helium-#{version}-#{arch}_linux", "helium"

  binary "helium/helium-wrapper", target: "helium"
  artifact "helium/helium.desktop",
           target: "#{ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"}/applications/helium.desktop"
  artifact "helium/product_logo_256.png",
           target: "#{ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"}/icons/hicolor/256x256/apps/helium.png"

  preflight_steps do
    inreplace "helium/helium.desktop", /^Exec=helium(.*)$/, "Exec={{HOMEBREW_PREFIX}}/bin/helium\\1"
    inreplace "helium/helium.desktop", /^StartupNotify=true$/, "StartupNotify=false"
  end

  zap trash: [
    "~/.cache/net.imput.helium",
    "~/.config/net.imput.helium",
  ]
end
