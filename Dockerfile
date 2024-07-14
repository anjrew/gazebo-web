ARG VERSION=11
FROM gazebo:libgazebo${VERSION}

# Install essential build tools and dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    x11-apps \
    mesa-utils \
    vim \
    llvm-dev \
    sudo \
    autoconf \
    wget \
    build-essential \
    gcc \
    g++ \
    make \
    pkg-config \
    python \
    libx11-dev \
    libxext-dev \
    libxcb1-dev \
    libxcb-glx0-dev \
    libxcb-dri2-0-dev \
    libxcb-dri3-dev \
    libxcb-present-dev \
    libxshmfence-dev \
    libxxf86vm-dev \
    libx11-xcb-dev \
    libxcb-dri2-0-dev \
    libxcb-xfixes0-dev \
    x11proto-dri2-dev \
    libtool \
    libdrm-dev \
    libelf-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN echo 'root:buttercups' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Rebuild MESA with llvmpipe (from https://turbovnc.org/Documentation/Mesa)
RUN wget ftp://ftp.freedesktop.org/pub/mesa/mesa-18.3.1.tar.gz && \
    tar -zxvf mesa-18.3.1.tar.gz && \
    rm mesa-18.3.1.tar.gz && \
    cd mesa-18.3.1 && \
    autoreconf -fiv && \
    ./configure \
        --enable-glx=gallium-xlib \
        --disable-dri \
        --disable-egl \
        --disable-gbm \
        --with-gallium-drivers=swrast \
        --enable-osmesa \
        --disable-driglx-direct \
        --with-dri-drivers= \
        --with-platforms=x11 \
        --prefix=$HOME/mesa && \
    make -j$(nproc) && \
    make install

# Set up locales
RUN apt-get update && apt-get install -y locales screen \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_GB.UTF-8 && locale-gen en_US.UTF-8

# Configure system to use new mesa
RUN cd ~ && echo "export LD_LIBRARY_PATH=/root/mesa/lib" > opengl.sh

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Start and expose the SSH service
EXPOSE 22
RUN service ssh restart

ARG VERSION
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    libsdformat4 \
    gazebo${VERSION} \
    gazebo${VERSION}-plugin-base \
    libignition-math2 \
    libignition-math2-dev \
    libsdformat4-dev \
    libgazebo${VERSION} \
    libgazebo${VERSION}-dev \
    libjansson-dev \
    nodejs \
    npm \
    nodejs-legacy \
    libboost-dev \
    imagemagick \
    libtinyxml-dev \
    mercurial \
    cmake \
    && rm -rf /var/lib/apt/lists/*


# Upgrade node
RUN curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
RUN apt-get install -y nodejs

# Clone gzweb
RUN cd ~ && \
    hg clone https://bitbucket.org/osrf/gzweb && \
    cd ~/gzweb && \
    hg up gzweb_1.4.0 && \
    source /usr/share/gazebo/setup.sh && \
    npm run deploy --- -m

# Setup environment
EXPOSE 8080
EXPOSE 7681

# Run gzserver and gzweb
COPY start_script.sh start_script.sh
CMD ./start_script.sh