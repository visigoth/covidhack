FROM pytorch/conda-cuda-cxx11-ubuntu1604:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y

RUN apt-get install -y apt-utils

RUN apt-get install -y ubuntu-release-upgrader-core

RUN apt-get dist-upgrade -y

RUN apt-get remove -y --allow-change-held-packages libnccl2 libnccl-dev

RUN do-release-upgrade -f DistUpgradeViewNonInteractive

COPY nccl*.deb /tmp

RUN dpkg -i /tmp/nccl*.deb

RUN conda init bash

RUN conda update -y -n base -c defaults conda

RUN conda create --name py36 -y python=3.6

RUN echo "conda activate py36" >> ~/.bashrc

RUN conda update -y --name py36 --all

RUN conda install -y --name py36 pytorch torchvision cudatoolkit=10.2 -c pytorch

RUN apt-get install -y \
  bison \
  gengetopt \
  help2man \
  gsl-bin \
  libgsl23 \
  libgslcblas0 \
  libgsl-dev \
  libmpfr6 \
  libmpfrc++-dev \
  libmpfr-dev \
  flex \
  libtool \
  pkg-config \
  python3-dev \
  texinfo \
  vim-common \
  swig

RUN mkdir /tmp/vienna

ADD ViennaRNA /tmp/vienna

WORKDIR /tmp/vienna/src

RUN tar zxf libsvm-3.23.tar.gz

WORKDIR /tmp/vienna

RUN autoreconf -i

RUN ./configure --with-kinwalker --with-cluster --without-perl

RUN make -j

RUN make check && make install

RUN conda develop -n py36 /usr/local/lib/python3.6/site-packages

RUN conda install -y -n py36 jupyter

RUN mkdir /notebooks && mkdir /python-modules && mkdir /data
