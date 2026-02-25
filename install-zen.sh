#! /bin/bash

read -p "you sure? quit if not" sureconfirm
echo "Ok"
set -e

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "Downloading Zen Browser..."
curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz" \
  -o "$TMP/zen.tar.xz"

echo "Extracting..."
tar -xf "$TMP/zen.tar.xz" -C "$TMP"

echo "Installing to /opt/zen/..."
sudo cp -r "$TMP/zen" /opt/

echo "Adding 'zen' to be linked..."
sudo ln -sf /opt/zen/zen /usr/local/bin/zen

echo "Creating app shortcut..."
sudo tee /usr/share/applications/zen-browser.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Zen Browser
Comment= Beautifully designed, privacy-focused, and packed with features.
Exec=/opt/zen/zen
Icon=/opt/zen/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=zen
EOF

echo "Creating desktop shortcut..."
sudo tee ~/Desktop/zen-browser.desktop > /dev/null <<EOF
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

echo "ZenBrowser installed! enjoy (installer by MalikHw47)"
