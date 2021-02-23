FROM nvcr.io/nvidia/l4t-base:r32.5.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt upgrade -y \
    && apt install -y \
     automake autoconf libpng-dev nano wget npm openjdk-8-jdk \
     curl zip unzip libtool swig zlib1g-dev pkg-config libprotoc-dev \
     git wget xz-utils python3-mock libpython3-dev libhdf5-dev \
     libpython3-all-dev python3-pip g++ gcc make protobuf-compiler \
     pciutils cpio gosu git liblapack-dev liblapacke-dev sox libsox-dev \
    && pip3 install --upgrade pip \
    && git clone -b v1.8.1 https://github.com/onnx/onnx.git \
    && cd onnx \
    && git submodule update --init --recursive \
    && sed -i -e "s/numpy>=1.16.6/numpy<=1.19.0/g" setup.py \
    && python3 setup.py install \
    && cd .. && rm -rf onnx \
    && pip3 install gdown \
    && pip3 install cmake \
    && pip3 install ninja \
    && pip3 install yapf \
    && pip3 install six \
    && pip3 install wheel \
    && pip3 install moc \
    && pip3 install cython \
    && pip3 install keras_applications==1.0.8 --no-deps \
    && pip3 install keras_preprocessing==1.1.0 --no-deps \
    && pip3 install numpy==1.19.0 \
    && pip3 install h5py==2.9.0 \
    && pip3 install pybind11 \
    && ldconfig

RUN gdown --id 1yCTPM2aAoc0N4_sFIziPFEOr6c7so0bS \
    && tar -zxvf usr.tar.gz -C / > /dev/null \
    && rm usr.tar.gz \
    && gdown --id 1uOZ_57GXBI05C6pITLLbMK4O2AcPw1jN \
    && mv nv_tegra_release /etc/ \
    && export PATH=${PATH}:/usr/local/cuda/bin \
    && gdown --id 1Vz5cWhNtGMYL8qHFJ5jgWUYVG-QNOJVY \
    && chmod +x bazel \
    && mv ./bazel /usr/local/bin

WORKDIR /workspace
