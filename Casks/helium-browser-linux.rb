cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"

  version "0.19.3.1"
  sha256 arm64_linux:  "5883d005bbc2092b27966a601f7153f446645693825a387c70bb22ed83a1a6f1",
         x86_64_linux: "8f4e012b5d921fa59269aaf9c54160abf7294c633b1a6aa5edb7725945314570"

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
