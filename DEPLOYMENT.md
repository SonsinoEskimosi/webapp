# Deployment Guide

## 🚀 CI/CD Setup for EC2

This project automatically deploys to EC2 when code is merged to the `main` branch.

### EC2 Details
- **IP Address:** 13.60.40.220
- **Public DNS:** ec2-13-60-40-220.eu-north-1.compute.amazonaws.com
- **Port:** 3000
- **App URL:** http://13.60.40.220:3000

---

## 📋 One-Time Setup

### Step 1: Prepare Your EC2 Instance

1. **SSH into your EC2 instance:**
   ```bash
   ssh -i webapp-connect.pem ec2-user@13.60.40.220
   ```

2. **Run the setup script:**
   ```bash
   # Copy the setup script to EC2
   # Then run it:
   chmod +x ec2-setup.sh
   ./ec2-setup.sh
   ```

   Or manually install requirements:
   ```bash
   # Update system
   sudo yum update -y
   
   # Install Node.js 20.x via NVM
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
   nvm install 20
   nvm use 20
   nvm alias default 20
   
   # Install git
   sudo yum install -y git
   
   # Make NVM permanent
   echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
   echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
   
   # Logout and login again for changes to take effect
   ```

3. **Set up your Git repository access** (if private repo):
   ```bash
   # Generate SSH key on EC2
   ssh-keygen -t ed25519 -C "your_email@example.com"
   
   # Display public key and add it as a Deploy Key in GitHub
   cat ~/.ssh/id_ed25519.pub
   ```

### Step 2: Configure GitHub Secrets

1. Go to your GitHub repository
2. Navigate to: **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add the following secret:

   **Name:** `EC2_SSH_KEY`
   
   **Value:** (Paste the entire content of your `webapp-connect.pem` file)
   ```
   -----BEGIN RSA PRIVATE KEY-----
   (your key content here)
   -----END RSA PRIVATE KEY-----
   ```

### Step 3: First Manual Deployment (Optional)

For the first deployment, you can manually deploy to test:

```bash
# SSH into EC2
ssh -i webapp-connect.pem ec2-user@13.60.40.220

# Clone your repository
cd /home/ec2-user
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git webapp
cd webapp

# Install and build
npm install
npm run build

# Start the app
nohup npm start > /home/ec2-user/webapp.log 2>&1 &
```

---

## 🔄 Automatic Deployment Workflow

Once setup is complete, deployments are automatic:

1. **Developer pushes to `main` branch**
2. **GitHub Actions triggers**
3. **Workflow connects to EC2 via SSH**
4. **Pulls latest code**
5. **Installs dependencies**
6. **Builds the application**
7. **Restarts the server**

### View Deployment Status

- Check the **Actions** tab in your GitHub repository
- Each push to `main` will show a deployment run

### View Logs on EC2

```bash
# SSH into EC2
ssh -i webapp-connect.pem ec2-user@13.60.40.220

# View application logs
tail -f /home/ec2-user/webapp.log

# Check if app is running
ps aux | grep "next start"

# Check what's listening on port 3000
sudo lsof -i :3000
```

---

## 🛠️ Manual Operations

### Restart the Application
```bash
ssh -i webapp-connect.pem ec2-user@13.60.40.220
pkill -f "next start"
cd /home/ec2-user/webapp
nohup npm start > /home/ec2-user/webapp.log 2>&1 &
```

### Stop the Application
```bash
ssh -i webapp-connect.pem ec2-user@13.60.40.220
pkill -f "next start"
```

### Check Application Status
```bash
ssh -i webapp-connect.pem ec2-user@13.60.40.220
ps aux | grep "next start"
```

---

## 🌐 Accessing Your Application

- **Direct IP:** http://13.60.40.220:3000
- **Public DNS:** http://ec2-13-60-40-220.eu-north-1.compute.amazonaws.com:3000

---

## 🔒 Security Considerations

1. **SSH Key:** Never commit your `.pem` file to the repository
2. **GitHub Secrets:** SSH key is stored securely in GitHub Secrets
3. **Firewall:** Only ports 22 (SSH) and 3000 (app) are open
4. **HTTPS:** Consider adding Nginx + Let's Encrypt for SSL in production

---

## 📝 Troubleshooting

### Deployment fails?
- Check GitHub Actions logs in the Actions tab
- Verify EC2_SSH_KEY secret is set correctly
- Ensure EC2 instance is running

### App not accessible?
- Check EC2 security group allows inbound traffic on port 3000
- Verify app is running: `ps aux | grep "next start"`
- Check logs: `tail -f /home/ubuntu/webapp.log`

### Port already in use?
```bash
# Find and kill process on port 3000
sudo lsof -ti:3000 | xargs kill -9
```

---

## 🎯 Next Steps (Optional Improvements)

1. **Add PM2 for process management** (auto-restart, better logging)
2. **Set up Nginx as reverse proxy** (serve on port 80/443)
3. **Add SSL certificate** with Let's Encrypt
4. **Set up custom domain**
5. **Add health checks** to the deployment workflow
6. **Implement blue-green deployment** for zero downtime

