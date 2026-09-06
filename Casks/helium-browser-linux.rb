cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"

  version "0.16.5.1"
  sha256 arm64_linux:  "d6b66411ad3666eb0b217724447dd172887a1d42b0e944646c4fc5fc5cdf9c1c",
         x86_64_linux: "f615a7735663584364086a2be93f0e79ba1238a856be6ddbb5aef73e7c94a970"

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
