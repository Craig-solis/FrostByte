#!/bin/bash

# Wait until the server has internet access
while ! ping -c 1 8.8.8.8 &> /dev/null; do
    sleep 5
done

# Get IP address info
IP_INFO=$(ifconfig -a)

# Get Hostname
HOSTNAME=$(hostname)

# Create plain text email content
EMAIL_CONTENT=$(cat <<EOF
Server Boot Notification
------------------------

Your server has successfully booted and is connected to the internet.

IP Address Information:
-----------------------
$IP_INFO

Sent automatically from your Ubuntu server.
EOF
)

# Send email using msmtp
echo "$EMAIL_CONTENT" | mail -s "Server IP Info from $HOSTNAME" craig.solis@techline-inc.com


