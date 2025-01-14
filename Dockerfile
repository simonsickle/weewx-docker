FROM --platform=$TARGETPLATFORM python:alpine as install-weewx-stage

ARG WEEWX_UID=421
ENV WEEWX_HOME="/home/weewx"
ENV WEEWX_VERSION="4.8.0"
ENV ARCHIVE="weewx-${WEEWX_VERSION}.tar.gz"

RUN addgroup --system --gid ${WEEWX_UID} weewx \
  && adduser --system --uid ${WEEWX_UID} --ingroup weewx weewx

RUN apk --no-cache add tar

WORKDIR /tmp
COPY requirements.txt ./

# Download sources and verify hashes
RUN wget -O "${ARCHIVE}" "https://weewx.com/downloads/released_versions/${ARCHIVE}"
RUN wget -O weewx-mqtt.zip https://github.com/matthewwall/weewx-mqtt/archive/master.zip
RUN wget -O weewx-weatherflowudp.zip https://github.com/captain-coredump/weatherflow-udp/archive/master.zip

# WeeWX setup
RUN tar --extract --gunzip --directory ${WEEWX_HOME} --strip-components=1 --file "${ARCHIVE}"
RUN chown -R weewx:weewx ${WEEWX_HOME}

# Python setup
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache --requirement requirements.txt

WORKDIR ${WEEWX_HOME}

RUN bin/wee_extension --install /tmp/weewx-mqtt.zip
RUN bin/wee_extension --install /tmp/weewx-weatherflowudp.zip
COPY src/entrypoint.sh ./

FROM --platform=$TARGETPLATFORM python:3.10-bullseye as final-stage

ARG TARGETPLATFORM
ARG WEEWX_UID=421
ENV WEEWX_HOME="/home/weewx"
ENV WEEWX_VERSION="4.8.0"

LABEL com.weewx.version=${WEEWX_VERSION}

RUN addgroup --system --gid ${WEEWX_UID} weewx \
  && adduser --system --uid ${WEEWX_UID} --ingroup weewx weewx

RUN apt-get update && apt-get install -y libusb-1.0-0 gosu busybox-syslogd tzdata

WORKDIR ${WEEWX_HOME}

COPY --from=install-weewx-stage /opt/venv /opt/venv
COPY --from=install-weewx-stage ${WEEWX_HOME} ${WEEWX_HOME}

RUN mkdir /data && \
  cp weewx.conf /data

VOLUME ["/data"]

ENV PATH="/opt/venv/bin:$PATH"
ENTRYPOINT ["./entrypoint.sh"]
CMD ["/data/weewx.conf"]
