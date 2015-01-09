# busybox-python

`Busybox 1.22.1` (with `Buildroot 2014.11`) container and rootfs builder for minimal Docker base images 
equipted with a staticly linked Python executable and easy_install.
Additionally `curl-7.39.0` with SSL/TLS support is included.

The rootfs build can be found in the tarmaker directory. It is heavily 
inspired by radial/core-busyboxplus.

Python interpreter is powered by eGenix PyRun™. `easy_install` version 
0.7.4 is part of the image. 
