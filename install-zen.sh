#!/bin/bash
set -euo pipefail

while true; do
    read -rp "Are you sure? (Y/N): " sureconfirm
    case "$sureconfirm" in
        [Yy]) break ;;
        [Nn]) echo "Cancelled."; exit 1 ;;
        *) echo "Please press Y or N." ;;
    esac
done

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "Downloading Zen Browser..."
curl -L \
  "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz" \
  -o "$TMP/zen.tar.xz"

echo "Extracting..."
tar -xf "$TMP/zen.tar.xz" -C "$TMP"

echo "Installing to /opt/zen..."
sudo rm -rf /opt/zen
sudo mv "$TMP/zen" /opt/

echo "Linking binary..."
sudo ln -sf /opt/zen/zen /usr/local/bin/zen

echo "Creating system desktop entry..."
sudo tee /usr/share/applications/zen-browser.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Zen Browser
Comment=Beautifully designed, privacy-focused, and packed with features.
Exec=/opt/zen/zen
Icon=/opt/zen/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=zen
EOF

echo "Creating user desktop shortcut..."
tee "$HOME/Desktop/zen-browser.desktop" > /dev/null <<EOF
[Desktop Entry]
Name=Zen Browser
Comment=Beautifully designed, privacy-focused, and packed with features.
Exec=/opt/zen/zen
Icon=/opt/zen/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=zen
EOF

chmod +x "$HOME/Desktop/zen-browser.desktop"

echo "Zen Browser installed successfully."