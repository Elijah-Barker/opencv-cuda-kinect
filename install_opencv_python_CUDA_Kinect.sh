#!/bin/bash
version=3.4.5
echo $version

# Dependencies
sudo apt-get install gcc-6 g++-6 g++-6-multilib gfortran-6 build-essential cython3 cmake unzip pkg-config libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libgtk-3-dev libatlas-base-dev gfortran python3-dev -y
sudo apt-get install openni-utils libopenni-dev libopenni-sensor-primesense-dev -y
sudo pip3 install numpy pycuda

mkdir -p ~/Downloads/opencv-python-CUDA-Kinect_$version
rm -rf ~/Downloads/opencv-python-CUDA-Kinect_$version/*
pushd ~/Downloads/opencv-python-CUDA-Kinect_$version

wget -O opencv.zip https://github.com/Itseez/opencv/archive/$version.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/$version.zip

unzip opencv.zip
unzip opencv_contrib.zip

mkdir -p opencv-$version/build
pushd opencv-$version/build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D WITH_CUDA=ON \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D CMAKE_C_COMPILER=/usr/bin/gcc-6 \
    -D CMAKE_CXX_COMPILER=/usr/bin/g++-6 \
    -DCUDA_NVCC_FLAGS=--expt-relaxed-constexpr \
    -D WITH_OPENNI=ON \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$version/modules \
    -D BUILD_EXAMPLES=ON -D ENABLE_PRECOMPILED_HEADERS=OFF ..

#    -D INSTALL_C_EXAMPLES=OFF \


#     -D ENABLE_NEON=ON -D ENABLE_VFPV3=ON \
#     -D BUILD_opencv_dnn=OFF \
#     -D BUILD_LIBPROTOBUF_FROM_SOURCES=ON \
#     -D WITH_LIBV4L=ON \
#     -D WITH_V4L=OFF \
#     -D PYTHON_EXECUTABLE=~/.virtualenvs/cv/bin/python \

time make -j8
sudo make install
sudo ldconfig
# opencv 4 only:
# [[ -d /usr/local/include/opencv2sudo ]] || sudo ln -s /usr/local/include/opencv4/opencv2 /usr/local/include/opencv2
sudo chown -R $USER:$USER ~/Downloads/opencv-python-CUDA-Kinect_$version
