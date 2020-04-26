# ML Framework for EteRNA Puzzles

Solve EteRNA puzzles using machine learning.

# CUDA Optional

While CUDA is optional, it will be helpful to run training algorithms on CUDA-enabled machines. The instructions below are tailored to 

# Docker Image

The Dockerfile creates an ubuntu-based PyTorch image that is compatible with CUDA. It automatically builds Vienna. In order to build, you will need to independently download NVIDIA's NCCL library package.

## Host System Pre-requisites

**CUDA is optional.** While CUDA is optional, the instructions below are tailored to working on a CUDA-enabled host machine. Enabling CUDA for your host machine is left as an exercise to the reader. The Dockerfile depends on NVIDIA's NCCL package for installation.

### Install Docker

Per your platform, install latest docker-engine from the docker web site. Do not use an older docker package from your operating system; rather install a newer docker from the web site using your preferred method. This is because docker version 19.03 added support for the `--gpus` option to make GPUs visible to containers. This is much easier than installing the NVIDIA container toolkit for use with older versions of docker.

```
> docker --version
Docker version 19.03.8, build afacb8b7f0
```

### Pull the prebuilt image

**If you just want the prebuilt docker image, you can use `docker pull visigoth/eternann:latest` and skip building your own image.**

## Build the image

`docker build -t eternann:latest .`

### Download NVIDIA NCCL Package

You will need to download NVIDIA's NCCL package on your own to build this image because it requires accepting their terms. Download the "local installer" package from [here](https://developer.nvidia.com/nccl/nccl-download) and place it in this directory for use by the `Dockerfile`.

## Try it out

To test things are working, try each of the following tests:

**Test CUDA is available**

```
> docker run --rm --gpus all eternann:latest nvidia-smi
Sun Apr 26 19:24:43 2020
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.33.01    Driver Version: 440.33.01    CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1080    On   | 00000000:01:00.0 Off |                  N/A |
| 27%   38C    P8     7W / 180W |      1MiB /  8116MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

**Test python resolves to python3.6 when running interactively**

```
> docker run --rm --gpus all eternann:latest
(py36) root@4eb6e4363e75:/tmp/vienna# python --version
Python 3.6.10 :: Anaconda, Inc.
```

**Test pytorch has CUDA available**

```
> docker run --rm --gpus all eternann:latest
(py36) root@4eb6e4363e75:/tmp/vienna# python -c "import torch; print('CUDA Available') if torch.cuda.is_available() else print('Nope')"
CUDA Available
```

**Running in conda from docker run**

Note that unless you initialize `bash` correctly, the default environment will be python2.7. In order to run a command from `docker run` without an interactive shell, `bash` must be invoked with `-i` to have it source `/root/.bashrc`:

```
> docker run --rm --gpus all -it eternann:latest /bin/bash -lic "python --version"
Python 3.6.10 :: Anaconda, Inc.
```

**Test ViennaRNA samples**

```
> docker run --rm -it --gpus all eternann:latest bash -lic "python /usr/local/share/ViennaRNA/examples/python/helloworld_mfe.py"
GAGUAGUGGAACCAGGCUAUGUUUGUGACUCGCAGACUAACA
..(((((........)))))(((((((...)))))))..... [  -8.80 ]

> docker run --rm -it --gpus all eternann:latest bash -lic "python /usr/local/share/ViennaRNA/examples/python/helloworld_mfe_comparative.py"
CUGCCUCACAACAUUUGUGCCUCAGUUACCCAUAGAUGUAGUGAGGGU
...((((((.(((((((((...........))))))))).)))))).. [ -10.86 ]

> docker run --rm -it --gpus all eternann:latest bash -lic "python /usr/local/share/ViennaRNA/examples/python/helloworld_nondefault.py"
GAGUAGUGGAACCAGGCUAUGUUUGUGACUCGCAGACUAACA
..(((((........)))))(((((((...)))))))..... [ -13.43 ]

> docker run --rm -it --gpus all eternann:latest bash -lic "python /usr/local/share/ViennaRNA/examples/python/oo_example1.py"
((.(((...)))))) [  -5.60 ]

> docker run --rm -it --gpus all eternann:latest bash -lic "python /usr/local/share/ViennaRNA/examples/python/subopt.py"
>subopt 1
GGGGAAAACCCC
(((......))) [ -2.70]
>subopt 2
GGGGAAAACCCC
((((....)))) [ -5.40]
>subopt 3
GGGGAAAACCCC
.(((.....))) [ -2.40]
>subopt 4
GGGGAAAACCCC
(((.....))). [ -4.20]
>subopt 5
GGGGAAAACCCC
.((......)). [ -0.40]
>subopt 6
GGGGAAAACCCC
.(((....))). [ -3.10]
>subopt 7
GGGGAAAACCCC
((......)).. [ -1.20]
>subopt 8
GGGGAAAACCCC
.((.....)).. [ -1.10]

> docker run --rm -it --gpus all eternann:latest bash -lic "python /usr/local/share/ViennaRNA/examples/python/RNAfold_MEA.py"
AUUUCCACUAGAGAAGGUCUAGAGUGUUUGUCGUUUGUCAGAAGUCCCUAUUCCAGGUACGAACACGGUGGAUAUGUUCGACGACAGGAUCGGCGCACUA
.......(((((.....)))))(((((..((((((((((.......(((.....)))..((((((.........))))))..))))))..))))))))). (-22.20)
.......(((((.....)))))(((((..(((({(((((.,..{,,{{{..,{.|,|,.{{{{{{,...,},,.})})))}})))))}..))))))))). [-24.66]
.......(((((.....)))))(((((..((((.(((((.....................((((...........))))...)))))...))))))))). [-15.20 d=14.12]
.......(((((.....)))))(((((..((((.(((((.......(.........)..((((((.........))))))..)))))...))))))))). [-16.60 MEA=75.49]
 frequency of mfe structure in ensemble 0.018328669418666253; ensemble diversity - 22.18
```

