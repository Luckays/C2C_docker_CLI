# Dockerfile to build CloudCompare CLI with LAS/LAZ and PCD support
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CC_PLUGIN_PATH="/opt/CloudCompare/build/plugins/core/IO/qLASIO:/opt/CloudCompare/build/plugins/core/Standard/qPCL:/opt/CloudCompare/build/plugins/core/Standard/qPCL/PclIO"
ENV QT_QPA_PLATFORM=offscreen

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    git cmake g++ build-essential \
    libqt5svg5-dev libqt5opengl5-dev qttools5-dev qttools5-dev-tools \
    libqt5websockets5-dev \
    libqt5gui5 \
    libpcl-dev \
    liblaszip-dev



# Clone CloudCompare repository with submodules
WORKDIR /opt
RUN git clone --recursive https://github.com/CloudCompare/CloudCompare.git

# Configure CMake with desired plugin support
WORKDIR /opt/CloudCompare
RUN mkdir build
WORKDIR /opt/CloudCompare/build
RUN cmake .. \
  -DPLUGIN_IO_QLAS=ON \
  -DPLUGIN_STANDARD_QPCL=ON \
  -DPLUGIN_IO_QLASFW=OFF \
  -DPLUGIN_IO_QPDAL=OFF \
  -DBUILD_CCVIEWER=OFF \
  -DBUILD_TESTING=OFF \
  -DCMAKE_BUILD_TYPE=Release

# Build CloudCompare
RUN make -j$(nproc)

# Symlink executable
RUN ln -s /opt/CloudCompare/build/qCC/CloudCompare /usr/local/bin/cloudcompare

# Set working directory for running conversions
WORKDIR /data

# Default command
ENTRYPOINT ["cloudcompare"]
