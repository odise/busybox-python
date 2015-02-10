#!/bin/sh
MODULE=busybox-python

docker build -t tarmaker:$MODULE tarmaker || {
    echo "Something went wrong. Aborting."
        exit 1
    }

[ -f rootfs.tar ] && mv rootfs.tar rootfs.tar.old
[ -f rootfs.tar.md5 ] && mv rootfs.tar.md5 rootfs.tar.md5.old

docker run --name builder-$MODULE tarmaker:$MODULE
docker cp builder-$MODULE:/tmp/rootfs.tar .
docker cp builder-$MODULE:/tmp/rootfs.tar.md5 .
docker cp builder-$MODULE:/tmp/.config .
#chown 1000:1000 $1/rootfs*

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias md5=md5sum
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias md5="md5 -r"
fi

grep $(md5 rootfs.tar | awk '{ print $1 }') rootfs.tar.md5
if [ $? -eq 0 ]; then
    docker rm -f builder-$MODULE && \
    docker rmi tarmaker:$MODULE && \
    # We must wait until all removal is done before next step
    docker build -t odise/$MODULE:2015.02 .
else
    echo "Checksum failed. Aborting."
    echo "Note: the tarmaker:$MODULE image and builder-$MODULE container have not been deleted."
    exit 1
fi
