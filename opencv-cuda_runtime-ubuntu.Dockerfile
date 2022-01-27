ARG CUDA_VERSION
FROM bryantrh/cuda:$CUDA_VERSION-runtime-ubuntu18.04

LABEL maintainer="bryantrh"

#install
RUN apt-get update \
    && apt-get install -y gcc make libssl-dev wget xz-utils git \
    && rm -rf /var/lib/apt/lists/*

#install ffmpeg
ARG FFMPEG_VERSION
ENV FFMPEG_VERSION $FFMPEG_VERSION

WORKDIR /opt
ENV GIT_SSL_NO_VERIFY=1
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && cd nv-codec-headers && make && make install && rm -rf /opt/nv-codec-headers
RUN wget -q https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz  &&  xz -d  ffmpeg-${FFMPEG_VERSION}.tar.xz && tar -xvf ffmpeg-${FFMPEG_VERSION}.tar &&  cd ffmpeg-${FFMPEG_VERSION} && \
     ./configure  --prefix=/usr/local/ffmpeg-${FFMPEG_VERSION}  --disable-static  --disable-stripping  --disable-doc  --enable-shared  --disable-x86asm  --enable-decoder=png --enable-encoder=png --enable-cuda --enable-cuvid --enable-nvenc --enable-openssl --enable-filter=movie && \
     make -j32 &&  make install && \
     echo "/usr/local/ffmpeg-${FFMPEG_VERSION}/lib" >>/etc/ld.so.conf && \
     ldconfig && \
     cd /opt && rm -rf  /opt/FFmpeg-${FFMPEG_VERSION}.tar.xz /opt/ffmpeg-${FFMPEG_VERSION}

ENV PATH=$PATH:/usr/local/ffmpeg-${FFMPEG_VERSION}/bin/

#install opencv
RUN apt-get update && apt-get install -y --no-install-recommends \
            git build-essential cmake pkg-config unzip libgtk2.0-dev \
            ca-certificates libcurl4-openssl-dev \
            libtbb2 libtbb-dev \
            libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev \
            wget curl bash  build-essential  && \
            rm -rf /var/lib/apt/lists/*

ARG OPENCV_VERSION
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
