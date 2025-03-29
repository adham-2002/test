#!/bin/bash

# Update system packages
apt update

# Install .NET runtime and SDK
echo "Installing .NET 6 runtime and SDK"
apt install -y aspnetcore-runtime-6.0 dotnet-sdk-6.0

# Install git and unzip (if needed)
echo "Installing Git and Unzip"
apt install -y git unzip

# Clone repository from GitHub
cd /home/ubuntu
echo "Cloning repository from GitHub"
git clone https://github.com/adham-2002/test.git
cd test

# Build the .NET application
echo "Building the .NET application"
echo 'DOTNET_CLI_HOME=/temp' >> /etc/environment
export DOTNET_CLI_HOME=/temp
dotnet publish -c Release --self-contained=false --runtime linux-x64

# Create systemd service file for the application
cat >/etc/systemd/system/srv-02.service <<EOL
[Unit]
Description=Dotnet S3 info service

[Service]
ExecStart=/usr/bin/dotnet /home/ubuntu/test/bin/Release/netcoreapp6/linux-x64/srv02.dll
SyslogIdentifier=srv-02
Environment=DOTNET_CLI_HOME=/temp

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd to recognize the new service
systemctl daemon-reload

# Start the service
systemctl start srv-02

echo "Deployment complete. The service should be running on port 8002."
