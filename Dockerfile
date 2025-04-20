# --- ベースイメージ（CUDA + ROS 2 Humble）---
FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu22.04

# --- 作業ディレクトリを /home に設定 ---
WORKDIR /home

# --- 環境変数 ---
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV HOME=/home

# --- 時刻と日本語ロケール設定 ---
RUN apt update && apt install -y tzdata locales && \
    ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    locale-gen ja_JP.UTF-8

# --- 開発に必要なパッケージをインストール ---
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    build-essential \
    git \
    git-lfs \
    curl \
    ca-certificates \
    lsb-release \
    gnupg \
    libsndfile1-dev \
    libgl1 \
    python3 \
    python3-pip \
    tmux \
    vim \
    && rm -rf /var/lib/apt/lists/*

# --- ROS 2 Humble のセットアップ ---
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list' && \
    apt update && \
    apt install -y ros-humble-desktop python3-colcon-common-extensions && \
    echo "source /opt/ros/humble/setup.bash" >> /home/.bashrc

# --- git-prompt.sh をインストールして読み込む ---
RUN curl -o /etc/profile.d/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# --- ユーザー設定ファイルのコピー ---
COPY config/.bashrc /home/.bashrc
COPY config/.vimrc /home/.vimrc
COPY config/.tmux.conf /home/.tmux.conf

# --- bashrc に git-prompt の読み込みとプロンプト設定を追加 ---
RUN echo 'source /etc/profile.d/git-prompt.sh' >> /home/.bashrc && \
    echo 'export PS1="\u@\h:\w\$(__git_ps1 \" (%s)\")\$ "' >> /home/.bashrc

# --- Python依存関係のインストール ---
COPY config/requirements.txt /home/requirements.txt
RUN pip3 install --no-cache-dir -U pip && \
    pip3 install --no-cache-dir --root-user-action=ignore -r requirements.txt

# --- CUDA対応のPyTorchをインストール（要バージョン調整）---
RUN pip3 install --timeout 100 --no-cache-dir --root-user-action=ignore \
    torch==2.0.0+cu117 \
    torchvision==0.15.0+cu117 \
    torchaudio==2.0.1+cu117 \
    -f https://download.pytorch.org/whl/torch_stable.html

# --- 最後に bash 起動（開発向け）---
CMD [ "bash" ]
