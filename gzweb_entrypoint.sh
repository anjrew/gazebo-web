#!/bin/bash
set -e

# Source ROS and Gazebo setup files
source /opt/ros/noetic/setup.bash
source /usr/share/gazebo/setup.sh

# Ensure nvm is set up
export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Log the Gazebo version
echo "Gazebo version:"
gazebo --version

# Start Gazebo server
gzserver --verbose &

# Start gzweb server
cd /gzweb
npm run deploy --- -m
npm start -p 8080
