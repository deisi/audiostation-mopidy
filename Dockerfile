FROM alpine:edge

RUN mkdir /etc/default && mkdir /etc/mopidy

##  Copy fallback configuration.
COPY mopidy.conf /etc/default/mopidy.conf

#  Copy default configuration.
COPY mopidy.conf /etc/mopidy/mopidy.conf

# Copy helper script.
COPY entrypoint.sh /entrypoint.sh

# Copy the pulse-client configuratrion.
COPY pulse-client.conf /etc/pulse/client.conf

RUN apk update \
  && apk upgrade \
  && apk add --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  gstreamer \
  glib-dev \
  gstreamer-dev \
  alsa-utils \
  python-dev \
  alpine-sdk \
  gst-plugins-good \
  gst-plugins-bad \
  gst-plugins-ugly \
  py-six \
  py-lxml \
  gst-libav \
  mopidy \
  py-pip \
  && pip install --upgrade pip \
  && pip install -U mopidy \
  && pip install Mopidy-MusicBox-Webclient
  #&& glib-compile-schemas /usr/share/glib-2.0/schemas


VOLUME ["/etc/mopidy", "/var/lib/mopidy"]

EXPOSE 6600 6680 5555/udp

ENTRYPOINT ["/entrypoint.sh"]
