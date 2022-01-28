# dockerfiles-opencv-ffmpeg-cuda-ubuntu
## Version
opencv + ffmpeg + cuda + ubuntu 

+ ubuntu:18.04
+ golang: 1.17.0
+ opencv: 4.4.0
+ nvidia/cuda: 11.0
+ ffmpeg: 5.0

# images
[https://hub.docker.com/u/bryantrh]

## opencv-cuda-runtime

+ bryantrh/opencv-cuda-runtime:${OPENCV_VERSION}-${CUDA_VERSION}-${FFMPEG_VERSION}

+ bryantrh/opencv-cuda-runtime:4.4.0-11.0-5.0

## opencv-cuda-devel
+ bryantrh/opencv-cuda-devel:${OPENCV_VERSION}-${CUDA_VERSION}-${FFMPEG_VERSION}
  
+ bryantrh/opencv-cuda-devel:4.4.0-11.0-5.0

## gocv-cuda-devel
+ bryantrh/gocv-cuda-devel:${GOLANG_VERSION}-${OPENCV_VERSION}-${CUDA_VERSION}-${FFMPEG_VERSION}
  
+ bryantrh/gocv-cuda-devel:1.17.0-4.4.0-11.0-5.0
