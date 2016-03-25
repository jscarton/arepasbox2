#!/usr/bin/env bash

echo "---------------------------------------------------------------"
echo "BOOTING SCRIPT"
echo "---------------------------------------------------------------"


echo "Starting MailHog"
nohup mailhog > /dev/null 2>&1 &

echo "Starting kibana"
nohup /opt/kibana-4.4.2-linux-x64/bin/kibana > /opt/kibana.out 2>&1&

echo "Configuring iptables"
iptables -F