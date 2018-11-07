FROM node:8
FROM node:8 AS build
ARG MAGICK_URL="http://imagemagick.org/download/releases"
ARG MAGICK_VERSION="7.0.8-14"

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 8277377A \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    libpng-dev libjpeg-dev libtiff-dev libopenjpeg-dev \
  && apt-get remove -y imagemagick \
  && cd /tmp \
  && curl -SLO "${MAGICK_URL}/ImageMagick-${MAGICK_VERSION}.tar.xz" \
  && curl -SLO "${MAGICK_URL}/ImageMagick-${MAGICK_VERSION}.tar.xz.asc" \
  && gpg --verify "ImageMagick-${MAGICK_VERSION}.tar.xz.asc" "ImageMagick-${MAGICK_VERSION}.tar.xz" \
  && tar xf "ImageMagick-${MAGICK_VERSION}.tar.xz" \
  && cd "ImageMagick-${MAGICK_VERSION}" \
  && ./configure \
    --disable-static \
    --enable-shared \
    --with-jpeg \
    --with-jp2 \
    --with-openjp2 \
    --with-png \
    --with-tiff \
    --with-quantum-depth=8 \
    --without-magick-plus-plus \
    --without-bzlib \
    --without-zlib \
    --without-dps \
    --without-fftw \
    --without-fpx \
    --without-djvu \
    --without-fontconfig \
    --without-freetype \
    --without-jbig \
    --without-lcms \
    --without-lcms2 \
    --without-lqr \
    --without-lzma \
    --without-openexr \
    --without-pango \
    --without-webp \
    --without-x \
    --without-xml \
  && make \
  && make install \
  && ldconfig /usr/local/lib \
  && apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /opt/pechtold
WORKDIR /opt/pechtold
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile
COPY docpad.coffee ./
COPY plugins ./plugins
COPY src ./src
RUN yarn build

FROM nginx:stable-alpine
#COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /opt/pechtold/out /usr/share/nginx/html
