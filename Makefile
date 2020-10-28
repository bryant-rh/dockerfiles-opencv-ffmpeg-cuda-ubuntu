OPENCV_VERSION := $(shell grep OPENCV_VERSION .version | cut -d '=' -f '2')
GOLANG_VERSION := $(shell grep GOLANG_VERSION .version | cut -d '=' -f 2)
PLATFORM := linux/amd64,linux/arm64

opencv:
	docker buildx build --push --platform=${PLATFORM}	\
		--file=opencv-ubuntu.Dockerfile \
		--tag=bryantrh/opencv-ubuntu:${OPENCV_VERSION}-ffmpeg	\
		--build-arg=OPENCV_VERSION=${OPENCV_VERSION}	\
		.


gocv:
	docker buildx build --push --progress plain \
		--platform=${PLATFORM} \
		--file=gocv-ubuntu.Dockerfile \
		--tag=bryantrh/gocv-ubuntu:${GOLANG_VERSION}-ffmpeg \
		--build-arg=GOLANG_VERSION=${GOLANG_VERSION}	\
		--build-arg=OPENCV_VERSION=${OPENCV_VERSION}	\
		.

