#!/bin/bash

# Define Scripts
SCRIPT_NAME="send_ip_email.sh"
SERVICE_NAME="sendip.service"
SMTP_CONFIG="/etc/msmtprc"

#Verifying Contents
if [[! -f $SCRIPT_NAME ]] || [[ ! -f $SERVICE_NAME ]]; then
  echo "Error: Required files not found!"
  exit 1
fi

# Update packages and install dependencies
echo "Installing Dependencies..."
sudo apt update && sudo apt install -y msmtp msmtp-mta

# Configure msmtprc with SMTP Credentials
echo "Setting up STMP Configuration..."
cat <<EOF | sudo tee $SMTP_CONFIG
#Configure SMTP settings for FrostBit Agent
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

account        gmail
host           smtp.gmail.com
port           587
from           "FrostByte Agent <csol.techline@gmail.com>"
user           csol.techline@gmail.com
password       myxo vdfl sjua pqag

account default : gmail
EOF

# Secure msmtprc
sudo chmod 600 $SMTP_CONFIG

# Move send_ip_email.sh to /usr/local/bin and set executable permissions
echo "Deploying Email Script ..."
sudo mv $SCRIPT_NAME /usr/local/bin/
sudo chmod +x /usr/local/bin/$SCRIPT_NAME

# Move sendip.service to systemd directory
echo "Setting up systemmd service ..."
sudo mv $SERVICE_NAME /etc/systemd/system/

# Reload systemd, enable, and start service
sudo systemctl deamon-reload
sudo systemctl enable sendip.service
sudo systemctl start sendip.service

echo "FrostBit Agent deployment completed successfully!"
