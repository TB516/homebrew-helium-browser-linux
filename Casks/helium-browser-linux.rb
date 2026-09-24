cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"

  version "0.18.1.1"
  sha256 arm64_linux:  "509ea4bfc617fff456f4584814894c6da71b3fe5b6d09637b08b4f3c76abec9e",
         x86_64_linux: "9f4d35239eea18b290846221874265ac2a8637adff954df69fdef77d6b15042c"

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
