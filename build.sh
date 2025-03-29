#!/bin/bash
apt update
echo "install dotnet"
apt install -y aspnetcore-runtime-6.0
apt install -y dotnet-sdk-6.0

# Install git and unzip
echo "install git"
apt install git
apt install unzip

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
./aws/install
aws --version

# Configure git for AWS CodeCommit
sudo -u ubuntu git config --global credential.helper '!aws codecommit credential-helper $@'
sudo -u ubuntu git config --global credential.UseHttpPath true

# Clone repo from CodeCommit
cd /home/ubuntu
echo "git clone"
sudo -u ubuntu git clone https://git-codecommit.eu-north-1.amazonaws.com/v1/repos/srv-02
cd srv-02

# Build .NET Service
echo "dotnet build"
echo 'DOTNET_CLI_HOME=/temp' >> /etc/environment
export DOTNET_CLI_HOME=/temp
dotnet publish -c Release --self-contained=false --runtime linux-x64

# Create systemd service file
cat >/etc/systemd/system/srv-02.service <<EOL
[Unit]
Description=Dotnet S3 info service

[Service]
ExecStart=/usr/bin/dotnet /home/ubuntu/srv-02/bin/Release/netcoreapp6/linux-x64/srv02.dll
SyslogIdentifier=srv-02

Environment=DOTNET_CLI_HOME=/temp

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload

# Run the service
systemctl start srv-02
