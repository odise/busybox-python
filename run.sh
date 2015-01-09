#!/bin/sh
[ "$1" ] || {
    echo "Specify which flavor of busybox to build:"
    ls -d */
    exit 1
    }
[ -d "$1" ] || {
    echo "Could not find directory $1."
        exit 1
    }

docker build -t tarmaker:$1 $1/tarmaker || {
    echo "Something went wrong. Aborting."
        exit 1
    }

[ -f $1/tarmaker/rootfs.tar ] && mv $1/tarmaker/rootfs.tar $1/tarmaker/rootfs.tar.old
[ -f $1/tarmaker/rootfs.tar.md5 ] && mv $1/tarmaker/rootfs.tar.md5 $1/tarmaker/rootfs.tar.md5.old

docker run --name builder-$1 tarmaker:$1
docker cp builder-$1:/tmp/rootfs.tar $1
docker cp builder-$1:/tmp/rootfs.tar.md5 $1
docker cp builder-$1:/tmp/.config $1
#chown 1000:1000 $1/rootfs*

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias md5=md5sum
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias md5="md5 -r"
fi

cd $1
grep $(md5 rootfs.tar | awk '{ print $1 }') rootfs.tar.md5
if $?; then
    docker rm -f builder-$1 &&\
    docker rmi tarmaker:$1 &&\
    # We must wait until all removal is done before next step
    docker build -t odise/busybox-$1:latest .
else
    echo "Checksum failed. Aborting."
    echo "Note: the tarmaker:$1 image and builder-$1 container have not been deleted."
    exit 1
fi
