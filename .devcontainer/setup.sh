set -e

echo "📦 Installing system dependencies..."
apt-get update && apt-get install -y curl unzip git

echo "📥 Installing Rojo..."
ROJO_VERSION="7.4.1"
curl -L -o rojo.zip "https://github.com/rojo-rbx/rojo/releases/download/v${ROJO_VERSION}/rojo-${ROJO_VERSION}-linux.zip"
unzip rojo.zip -d /usr/local/bin
chmod +x /usr/local/bin/rojo
rm rojo.zip

echo "🦀 Installing Lune..."
cargo install lune

echo "🌒 Installing Darklua..."
cargo install darklua

echo "🧱 Installing Rokit..."
npm install -g @rojo-rbx/rokit

echo "✅ Environment setup complete!"