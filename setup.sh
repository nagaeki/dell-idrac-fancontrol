#!/bin/bash

apt update && apt install lm-sensors ipmitool -y
sensors-detect --auto
ipmitool raw 0x30 0x30 0x01 0x00

wget https://github.com/nagaeki/dell-idrac-fancontrol/raw/main/fancontrol.sh -O /etc/fancontrol.sh
chmod +x /etc/fancontrol.sh
wget https://github.com/nagaeki/dell-idrac-fancontrol/raw/main/fancontrol.service -O /etc/systemd/system/fancontrol.service
systemctl daemon-reload
systemctl enable fancontrol --now