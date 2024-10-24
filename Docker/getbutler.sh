#!/usr/bin/bash

mkdir -p /opt/butler/bin 
cd /opt/butler/bin

wget -O butler.zip https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default
unzip butler.zip

# GNU unzip tends to not set the executable bit even though it's set in the .zip
chmod +x butler

export PATH=/opt/butler/bin/:$PATH
cd ~
