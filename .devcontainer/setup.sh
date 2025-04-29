set -e

echo "🔧 Installing system packages..."
sudo apt-get update
sudo apt-get install -y curl unzip git

echo "🚀 Installing Rokit..."
curl -sSf https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash

export PATH="$HOME/.rokit/bin:$PATH"

echo "✅ Rokit installed at: $(which rokit)"
echo "🔍 Rokit version:"
rokit --version || echo "Rokit not found in PATH"

echo "📦 Adding required tools via Rokit..."
rokit add rojo-rbx/rojo || echo "Failed to add Rojo"
rokit add lune-org/lune || echo "Failed to add Lune"
rokit add seaofvoices/darklua || echo "Failed to add Darklua"

echo "📥 Installing tools..."
rokit install || echo "Rokit install failed"

echo "🧪 Verifying installations..."
echo -n "Rojo version: " && rojo --version || echo "❌ rojo not found"
echo -n "Lune version: " && lune --version || echo "❌ lune not found"
echo -n "Darklua version: " && darklua --version || echo "❌ darklua not found"

echo "✅ Environment setup complete."