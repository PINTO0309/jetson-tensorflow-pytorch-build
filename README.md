# jetson-tensorflow-pytorch-build
Provides an environment for compiling TensorFlow or PyTorch with CUDA for aarch64 on an x86 machine. This is for Jetson.

### Usage1. Launching the Jetson Nano (aarch64) cross-compilation environment on an x86 machine
```bash
$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
$ docker run -it --rm \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    pinto0309/l4t-base:r32.5.0 bash
```


### Usage2. Launching the Jetson Nano (aarch64) compilation environment on an EC2 aarch64 machine
```bash
$ docker run -it --rm \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    pinto0309/l4t-base:r32.5.0 bash
```
