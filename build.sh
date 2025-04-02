#!/bin/bash

# Update packages and install dependencies
sudo apt-get update -y
sudo apt-get install -y git

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone repository
git clone https://github.com/adham-2002/test.git
cd test

# Install project dependencies
npm install

# Create systemd service to keep the app running
sudo tee /etc/systemd/system/portfolio.service > /dev/null <<EOF
[Unit]
Description=Portfolio App
After=network.target

[Service]
User=$USER
WorkingDirectory=$(pwd)
ExecStart=$(which node) index.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable portfolio.service
sudo systemctl start portfolio.service