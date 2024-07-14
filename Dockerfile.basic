# Use the official ROS Noetic base image
FROM ros:noetic-ros-core

# Install necessary packages
RUN apt-get update && apt-get install -y \
    gazebo11 \
    ros-noetic-gazebo-ros-pkgs \
    ros-noetic-gazebo-ros-control \
    curl \
    git \
    mercurial \
    cmake \
    build-essential \
    libjansson-dev \
    libboost-dev \
    imagemagick \
    libtinyxml-dev \
    && rm -rf /var/lib/apt/lists/*

# Install nvm, node, and npm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 8 && \
    nvm use 8 && \
    nvm alias default 8 && \
    ln -s $NVM_DIR/versions/node/v8/bin/node /usr/bin/node && \
    ln -s $NVM_DIR/versions/node/v8/bin/npm /usr/bin/npm

# Ensure nvm is available in future RUN commands
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 8
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install node and npm using nvm
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION"

# Install gzweb
RUN git clone https://github.com/osrf/gzweb.git /gzweb 
WORKDIR /gzweb
RUN git checkout gzweb_1.4.1 
# Ensure nvm is set up before running npm install
RUN /bin/bash -c "source /usr/share/gazebo/setup.sh && npm install"

WORKDIR /
# Set environment variables
ENV GAZEBO_MODEL_PATH=/usr/share/gazebo-11/models

# Copy the entrypoint script
COPY gzweb_entrypoint.sh /gzweb_entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /gzweb_entrypoint.sh
