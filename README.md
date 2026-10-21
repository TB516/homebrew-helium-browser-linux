# Unofficial Linux Homebrew cask for Helium browser

## Deprecated and unmaintained

This unofficial tap is no longer maintained and is being retired. It will not receive browser updates, including security updates.

Use [Helium's official downloads](https://helium.computer/) instead. This notice applies to this tap, not to the upstream Helium project.

## Uninstallation

After moving to another installation, remove the cask and tap:

```sh
brew uninstall --cask helium-browser-linux
brew untap tb516/helium-browser-linux
```

To also delete your Helium profile and cache, use `brew uninstall --cask --zap helium-browser-linux` instead. This deletes your browser data, so back it up or migrate it first.
