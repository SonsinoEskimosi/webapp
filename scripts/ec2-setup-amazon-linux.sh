#!/bin/bash

# EC2 Initial Setup Script for Amazon Linux
# Run this ONCE on your EC2 instance to prepare it for deployments

set -e

echo "🚀 Setting up Amazon Linux EC2 for Next.js deployment..."

# Update system
echo "📦 Updating system packages..."
sudo yum update -y

# Install Node.js 20.x using NVM (recommended for Amazon Linux)
echo "📦 Installing Node.js via NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js 20
nvm install 20
nvm use 20
nvm alias default 20

# Verify installation
echo "✅ Node.js version: $(node --version)"
echo "✅ npm version: $(npm --version)"

# Install git if not present
echo "📦 Installing git..."
sudo yum install -y git

# Create webapp directory structure
echo "📁 Creating application directory..."
cd /home/ec2-user
if [ ! -d "webapp" ]; then
  echo "Clone your repository manually or the first deployment will do it"
fi

# Create log file
touch /home/ec2-user/webapp.log

# Add NVM to bash profile for persistence
echo "" >> ~/.bashrc
echo "# NVM Configuration" >> ~/.bashrc
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc

echo ""
echo "✅ EC2 setup completed!"
echo ""
echo "📝 Next steps:"
echo "1. Make sure your GitHub repository has access to this EC2 instance"
echo "2. Add your SSH private key as a GitHub Secret named 'EC2_SSH_KEY'"
echo "3. Configure EC2 Security Group to allow inbound traffic on port 80 (HTTP)"
echo "4. Push to main branch to trigger deployment"
echo ""
echo "🌐 Your app will be available at: http://13.60.40.220"
echo ""
echo "⚠️  IMPORTANT: Logout and login again for NVM to work properly!"

