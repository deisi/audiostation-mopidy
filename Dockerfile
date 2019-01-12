FROM debian:stretch-slim

RUN set -ex \
    # Official Mopidy install for Debian/Ubuntu along with some extensions
    # (see https://docs.mopidy.com/en/latest/installation/debian/ )
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        dumb-init \
        gcc \
        gnupg \
        gstreamer1.0-alsa \
        gstreamer1.0-plugins-bad \
        python-crypto \
 && curl -L https://apt.mopidy.com/mopidy.gpg | apt-key add - \
 && curl -L https://apt.mopidy.com/mopidy.list -o /etc/apt/sources.list.d/mopidy.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        mopidy \
        mopidy-soundcloud \
        mopidy-spotify \
 && curl -L https://bootstrap.pypa.io/get-pip.py | python - \
 && pip install -U six \
 && pip install \
        Mopidy-Moped \
        Mopidy-MusicBox-Webclient \
        Mopidy-GMusic \
        Mopidy-Pandora \
        Mopidy-YouTube \
        cryptography \
        pyasn1 \
        pyopenssl \
        requests[security] \
        youtube-dl \
 && apt-get purge --auto-remove -y \
        curl \
        gcc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

#  Copy fallback configuration.
COPY mopidy.conf /etc/default/mopidy.conf

#  Copy default configuration.
COPY mopidy.conf /etc/mopidy/mopidy.conf

# Copy helper script.
COPY entrypoint.sh /entrypoint.sh

# Copy the pulse-client configuratrion.
COPY pulse-client.conf /etc/pulse/client.conf

# Allows any user to run mopidy, but runs by default as a randomly generated UID/GID.
#ENV HOME=/var/lib/mopidy
#RUN set -ex \
# && usermod -u 84044 mopidy \
# && groupmod -g 84044 audio \
# && chown mopidy:audio -R $HOME /entrypoint.sh \
# && chmod go+rwX -R $HOME /entrypoint.sh

# Runs as mopidy user by default.
# USER mopidy

VOLUME ["/etc/mopidy", "/var/lib/mopidy"]

EXPOSE 6600 6680 5555/udp

ENTRYPOINT [  "/usr/bin/dumb-init", "/entrypoint.sh" ]
#CMD [ "/usr/bin/mopidy --config /etc/mopidy/mopidy.conf" ]
