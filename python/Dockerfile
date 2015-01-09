FROM scratch

ADD rootfs.tar /

# install standalone python binary
ADD pyrun2.7 /bin/python2.7
RUN ln -s /bin/python2.7 /bin/python2
RUN ln -s /bin/python2.7 /bin/python
RUN ln -s /usr/lib/libbz2.so.1.0 /usr/lib/libbz2.so.1

RUN mkdir -p /lib/python2.7/site-packages/
RUN mkdir -p /include/python2.7/

CMD [ "/bin/sh" ]
