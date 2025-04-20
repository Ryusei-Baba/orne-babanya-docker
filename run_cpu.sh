#!/bin/bash

# X11表示のために必要な環境変数を設定
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]; then
  touch $XAUTH
  xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
fi

# Docker実行
eval "docker container run \
  --network host \
  -it \
  --name humble-devel \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v $XAUTH:$XAUTH \
  -e XAUTHORITY=$XAUTH \
  -e QT_X11_NO_MITSHM=1 \
  -v $PWD/docker_share:/home/host_files \
  --ipc=host \
  --privileged \
  ryuseibaba/orne-babanya:latest"
