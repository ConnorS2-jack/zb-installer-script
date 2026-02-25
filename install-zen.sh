#!/bin/sh
set -eu

while :; do
    printf "Are you sure? (Y/N): "
    read sureconfirm || exit 1
    case "$sureconfirm" in
        Y|y) break ;;
        N|n) echo "Cancelled."; exit 1 ;;
        *) echo "Please type Y or N." ;;
    esac
done

TMP=$(mktemp -d) || exit 1
trap 'rm -rf "$TMP"' EXIT INT TERM

echo "Downloading Zen Browser..."
curl -fL \
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
sudo sh -c "cat > /usr/share/applications/zen-browser.desktop" <<EOF
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
mkdir -p "$HOME/Desktop"
cat > "$HOME/Desktop/zen-browser.desktop" <<EOF
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