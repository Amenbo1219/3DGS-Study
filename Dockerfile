ARG CUDA_VERSION=11.8.0
ARG OS_VERSION=22.04
ARG CUDA_ARCHITECTURES=90;89;86;80;75;70;61;52;37
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${OS_VERSION}
ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_HOME="/usr/local/cuda"

# パッケージの追加とタイムゾーンの設定
# 必要に応じてインストールするパッケージを追加してください
RUN apt-get update && apt-get install -y \ 
    tzdata \
    git \ 
    wget \
    libatlas-base-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libhdf5-dev \
    libcgal-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libgflags-dev \
    libglew-dev \
    libgoogle-glog-dev \
    libmetis-dev \
    libprotobuf-dev \
    libqt5opengl5-dev \
    libsqlite3-dev \
    libsuitesparse-dev \
    libglib2.0-0 \
    libsm6  \ 
    libxrender1  \ 
    libxext6 \
    libgl1-mesa-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev \
    cmake \
    ninja-build \
    colmap \
````python3-pip \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/*
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
# JupyterLab関連のパッケージ（いくつかの拡張機能を含む）
# 必要に応じて、JupyterLabの拡張機能などを追加してください
WORKDIR /opt
# Install GLOG (required by ceres).
RUN git clone --branch v0.6.0 https://github.com/google/glog.git --single-branch && \
    cd glog && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j `nproc` && \
    make install && \
    cd ../.. && \
    rm -rf glog
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
# Install Ceres-solver (required by colmap).
RUN git clone --branch 2.1.0 https://ceres-solver.googlesource.com/ceres-solver.git --single-branch && \
    cd ceres-solver && \
    git checkout $(git describe --tags) && \
    mkdir build && \
    cd build && \
    cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
    make -j `nproc` && \
    make install && \
    cd ../.. && \
    rm -rf ceres-solver

# Install colmap.
RUN git clone --branch 3.8 https://github.com/colmap/colmap.git --single-branch && \
    cd colmap && \
    mkdir build && \
    cd build && \
    cmake .. -DCUDA_ENABLED=ON \
             -DCMAKE_CUDA_ARCHITECTURES=${CUDA_ARCHITECTURES} && \
    make -j `nproc` && \
    make install && \
    cd ../.. && \
    rm -rf colmap


WORKDIR /install 
RUN pip3 install --upgrade pip  
RUN pip3 install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu118 && \
pip3 install --no-cache-dir \
    tqdm black \
    jupyterlab==3.6.7 \
    jupyterlab_code_formatter \
    jupyterlab-git \
    lckr-jupyterlab-variableinspector \
    jupyterlab_widgets \
    ipywidgets \
    import-ipynb



WORKDIR /work
CMD ["/bin/bash"]
