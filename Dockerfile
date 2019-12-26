#################################
###      MAPSERVER 7.4.3      ###
#################################

FROM alpine:3.10.3

LABEL maintainer="imbrechts.kevin+mapserver@protonmail.com"

ENV LASTREFRESH="20191219" \
    MAPSERVER_VERSION="7.4.3" \
    ORACLE_HOME=/opt/instantclient \
    LD_LIBRARY_PATH=${ORACLE_HOME}:/usr/lib

RUN apk update && \
    apk add --no-cache --virtual utils \
            bison=3.3.2-r0 \
            build-base=0.5-r1 \
            bzip2=1.0.6-r7 \
            ca-certificates=20190108-r0 \
            cairo=1.16.0-r2 \
            cmake=3.14.5-r0 \
            curl=7.66.0-r0 \
            curl-dev=7.66.0-r0 \
            fcgi-dev=2.4.0-r8 \
            flex=2.6.4-r2 \
            freetype-dev=2.10.0-r0  \
            gcc=8.3.0-r0 \
            libaio=0.3.111-r0 \
            libc-dev=0.7.1-r0 \
            libjpeg-turbo=2.0.3-r0 \
            libjpeg-turbo-dev=2.0.3-r0 \
            libuuid=2.33.2-r0 \
            #libxml2=2.9.9-r2 \
            #libxml2-dev=2.9.9-r2 \
            make=4.2.1-r2 \
            postgresql-client=11.6-r0 \
            postgresql-dev=11.6-r0 \
            python3-dev=3.7.5-r1 \
            wget=1.20.3-r0

#python-numpy python-software-properties software-properties-common libfcgi-dev

WORKDIR /tmp

RUN wget http://download.osgeo.org/mapserver/mapserver-${MAPSERVER_VERSION}.tar.gz && \
    tar zxvf mapserver-${MAPSERVER_VERSION}.tar.gz -C / && \
    mv /mapserver-${MAPSERVER_VERSION} /mapserver

WORKDIR /mapserver

RUN mkdir /mapserver/build && \
    cd build/ && \
    cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_CURL=ON \
    -DWITH_LIBXML2=ON \
    -DWITH_ORACLESPATIAL=ON \
    -DWITH_POINT_Z_M=ON \
    -DWITH_FCGI=ON \
    -DWITH_POSTGIS=ON \
    -DWITH_POSTGRES=ON \
    -DWITH_CLIENT_WFS=OFF \
    -DWITH_CLIENT_WMS=OFF \
    -DWITH_GDAL=OFF \
    -DWITH_GEOS=OFF \
    -DWITH_GIF=OFF \
    -DWITH_ICONV=OFF \
    -DWITH_KML=OFF \
    -DWITH_OGR=OFF \
    -DWITH_PROJ=OFF \
    -DWITH_SOS=OFF \
    -DWITH_THREAD_SAFETY=OFF \
    -DWITH_WCS=OFF \
    -DWITH_WFS=OFF \
    -DWITH_WMS=OFF \
    -DWITH_FRIBIDI=OFF \
    -DWITH_CAIRO=OFF \
    -DWITH_HARFBUZZ=OFF \
    -DWITH_LIBXML2=OFF \
    -DWITH_PROTOBUFC=OFF \
    ..

# Cleaning
RUN rm -f /tmp/mapserver-${MAPSERVER_VERSION}.tar.gz

CMD ["/bin/sh"]
