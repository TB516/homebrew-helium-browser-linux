cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"

  version "0.17.2.1"
  sha256 arm64_linux:  "e96629974b88b87f2928f36777313d6aa4f29b8b80d8cc7839fa7ee91786ed1d",
         x86_64_linux: "2a639df54e3d05f413cfbb4622a4d1a68584b31da5a7aaf58ee3cd83c7c3e299"

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
