#!/bin/bash

# EC2 Initial Setup Script
# Run this ONCE on your EC2 instance to prepare it for deployments

set -e

echo "🚀 Setting up EC2 instance for Next.js deployment..."

# Update system
echo "📦 Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install Node.js (using NodeSource)
echo "📦 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installation
echo "✅ Node.js version: $(node --version)"
echo "✅ npm version: $(npm --version)"

# Install git if not present
echo "📦 Installing git..."
sudo apt install -y git

# Create webapp directory
echo "📁 Creating application directory..."
cd /home/ubuntu
if [ ! -d "webapp" ]; then
  echo "Clone your repository manually or the first deployment will do it"
fi

# Configure firewall (if using UFW)
echo "🔥 Configuring firewall..."
sudo ufw allow 22
sudo ufw allow 3000
echo "y" | sudo ufw enable || true

# Create log file
touch /home/ubuntu/webapp.log

echo ""
echo "✅ EC2 setup completed!"
echo ""
echo "📝 Next steps:"
echo "1. Make sure your GitHub repository has access to this EC2 instance"
echo "2. Add your SSH private key as a GitHub Secret named 'EC2_SSH_KEY'"
echo "3. Push to main branch to trigger deployment"
echo ""
echo "🌐 Your app will be available at: http://13.60.40.220:3000"

