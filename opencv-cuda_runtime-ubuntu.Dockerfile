FROM bryantrh/cuda:11.1-runtime-ubuntu18.04

LABEL maintainer="bryantrh"

RUN apt-get update && apt-get install -y --no-install-recommends \
            git build-essential cmake pkg-config unzip libgtk2.0-dev \
            curl ca-certificates libcurl4-openssl-dev libssl-dev \
            libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev \
            libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev \
            gcc git wget curl unzip bash make build-essential  && \
            rm -rf /var/lib/apt/lists/*

#install ffmpeg-3.4
ADD ./FFmpeg-release-3.4 /opt/FFmpeg-release-3.4/
RUN cd /opt/FFmpeg-release-3.4/ && \ 
     ./configure  --prefix=/usr/local/ffmpeg-3.4  --disable-static  --disable-stripping  --disable-doc  --enable-shared  --disable-x86asm  --enable-openssl && \
     make -j -s &&  make install && \
     echo "/usr/local/ffmpeg-3.4/lib" >>/etc/ld.so.conf && \
     ldconfig && \
     rm -rf  /opt/FFmpeg-release-3.4/

ENV PATH=$PATH:/usr/local/ffmpeg-3.4/bin/

#install opencv-4.4.0
ARG OPENCV_VERSION="4.4.0"
ENV OPENCV_VERSION $OPENCV_VERSION

RUN curl -Lo opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
            unzip -q opencv.zip && \
            curl -Lo opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
            unzip -q opencv_contrib.zip && \
            rm opencv.zip opencv_contrib.zip && \
            cd opencv-${OPENCV_VERSION} && \
            mkdir build && cd build && \
            cmake -D CMAKE_BUILD_TYPE=RELEASE \
                  -D CMAKE_INSTALL_PREFIX=/usr/local \
                  -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
                  -D WITH_JASPER=OFF \
                  -D BUILD_DOCS=OFF \
                  -D BUILD_EXAMPLES=OFF \
                  -D BUILD_TESTS=OFF \
                  -D BUILD_PERF_TESTS=OFF \
                  -D BUILD_opencv_java=NO \
                  -D BUILD_opencv_python=NO \
                  -D BUILD_opencv_python2=NO \
                  -D BUILD_opencv_python3=NO \
                  -D OPENCV_GENERATE_PKGCONFIG=ON .. && \
            make -j $(nproc --all) && \
            make preinstall && make install && ldconfig && \
            cd / && rm -rf opencv*
