# jetson-tensorflow-pytorch-build
Provides an environment for compiling TensorFlow or PyTorch with CUDA for aarch64 on an x86 machine. This is for Jetson. If you build using an EC2 m6g.16xlarge (aarch64) instance, TensorFlow can be fully built in about 30 minutes.

## 1. Usage
### Usage1. Launching the Jetson Nano (aarch64) cross-compilation environment on an x86 machine
```bash
$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```
Next.
```bash
$ docker run -it --rm pinto0309/l4t-base:r32.5.0
```
or
```
$ docker run -it --rm \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    pinto0309/l4t-base:r32.5.0 bash
```

### Usage2. Launching the Jetson Nano (aarch64) compilation environment on an EC2 aarch64 machine
```bash
$ docker run -it --rm pinto0309/l4t-base:r32.5.0
```
or
```bash
$ docker run -it --rm \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    pinto0309/l4t-base:r32.5.0 bash
```

## 2. Example
### 2-1. TensorFlow build example
**`--local_ram_resources=n`** is the maximum size of RAM that the build process is allowed to use. **`--local_cpu_resources=n`** is the number of parallel execution of the build process. For x86 CPUs with hyper-threading enabled, the maximum number is twice the number of cores. For x86 CPUs with hyper-threading disabled, the number of cores is the maximum number. Note that a single build process can consume up to 2GB~4GB of RAM.
```
# TENSORFLOWVER=v2.4.1

# git clone -b ${TENSORFLOWVER} https://github.com/tensorflow/tensorflow.git
# cd tensorflow
# ./configure

You have bazel 3.1.0- (@non-git) installed.
Please specify the location of python. [Default is /usr/bin/python3]: 


Found possible Python library paths:
  /usr/local/lib/python3.6/dist-packages
  /usr/lib/python3/dist-packages
Please input the desired Python library path to use.  Default is [/usr/local/lib/python3.6/dist-packages]

Do you wish to build TensorFlow with ROCm support? [y/N]: n
No ROCm support will be enabled for TensorFlow.

Do you wish to build TensorFlow with CUDA support? [y/N]: y
CUDA support will be enabled for TensorFlow.

Do you wish to build TensorFlow with TensorRT support? [y/N]: y
No TensorRT support will be enabled for TensorFlow.

Found CUDA 10.2 in:
    /usr/local/cuda-10.2/targets/aarch64-linux/lib
    /usr/local/cuda-10.2/targets/aarch64-linux/include
Found cuDNN 8 in:
    /usr/lib/aarch64-linux-gnu
    /usr/include


Please specify a list of comma-separated CUDA compute capabilities you want to build with.
You can find the compute capability of your device at: https://developer.nvidia.com/cuda-gpus. Each capability can be specified as "x.y" or "compute_xy" to include both virtual and binary GPU code, or as "sm_xy" to only include the binary code.
Please note that each additional compute capability significantly increases your build time and binary size, and that TensorFlow only supports compute capabilities >= 3.5 [Default is: 3.5,7.0]: 


Do you want to use clang as CUDA compiler? [y/N]: n
nvcc will be used as CUDA compiler.

Please specify which gcc should be used by nvcc as the host compiler. [Default is /usr/bin/gcc]: 


Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -Wno-sign-compare]: 


Would you like to interactively configure ./WORKSPACE for Android builds? [y/N]: n
Not configuring the WORKSPACE for Android builds.

Preconfigured Bazel build configs. You can use any of the below by adding "--config=<>" to your build command. See .bazelrc for more details.
	--config=mkl         	# Build with MKL support.
	--config=mkl_aarch64 	# Build with oneDNN support for Aarch64.
	--config=monolithic  	# Config for mostly static monolithic build.
	--config=ngraph      	# Build with Intel nGraph support.
	--config=numa        	# Build with NUMA support.
	--config=dynamic_kernels	# (Experimental) Build kernels into separate shared objects.
	--config=v2          	# Build TensorFlow 2.x instead of 1.x.
Preconfigured Bazel build configs to DISABLE default on features:
	--config=noaws       	# Disable AWS S3 filesystem support.
	--config=nogcp       	# Disable GCP support.
	--config=nohdfs      	# Disable HDFS support.
	--config=nonccl      	# Disable NVIDIA NCCL support.
Configuration finished

# bazel build \
  --config=cuda \
  --config=noaws \
  --config=nohdfs \
  --config=nonccl \
  --config=v2 \
  #--local_ram_resources=16384 \
  #--local_cpu_resources=6 \
  //tensorflow/tools/pip_package:build_pip_package
```
### 2-2. PyTorch build example
```
# TORCHVER=v1.7.1
# VISIONVER=v0.8.2
# AUDIOVER=v0.7.2

# git clone -b ${TORCHVER} --recursive https://github.com/pytorch/pytorch
# cd /pytorch \
    && sed -i -e "/^if(DEFINED GLIBCXX_USE_CXX11_ABI)/i set(GLIBCXX_USE_CXX11_ABI 1)" \
                 CMakeLists.txt \
    && pip3 install -r requirements.txt \
    && python3 setup.py build \
    && python3 setup.py bdist_wheel \
    && cd ..

# pip3 install /pytorch/dist/*.whl \

# git clone -b ${VISIONVER} https://github.com/pytorch/vision.git
# cd /vision \
    && python3 setup.py build \
    && python3 setup.py bdist_wheel \
    && cd ..

# git clone -b ${AUDIOVER} https://github.com/pytorch/audio.git
# cd /audio \
    && apt-get install -y sox libsox-dev \
    && python3 setup.py build \
    && python3 setup.py bdist_wheel \
    && cd ..
```
