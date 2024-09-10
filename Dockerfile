FROM anapsix/alpine-java

ARG kafka_version=1.0.0
ARG scala_version=2.12
RUN apk add --update linux-headers
RUN apk add --update unzip wget curl jq coreutils tcpdump
RUN apk add --update python python-dev py-pip build-base gcc make
RUN pip install --upgrade pip
RUN pip install --upgrade google-cloud-pubsub

ENV KAFKA_VERSION=$kafka_version SCALA_VERSION=$scala_version
ADD download-kafka.sh /tmp/download-kafka.sh
RUN chmod a+x /tmp/download-kafka.sh && sync && /tmp/download-kafka.sh && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

ENV KAFKA_HOME /opt/kafka
ENV PATH ${PATH}:${KAFKA_HOME}/bin
ADD start-kafkaMirrorMaker.sh /usr/bin/start-kafkaMirrorMaker.sh

ADD config/*.template /opt/kafka/config/
RUN mkdir /opt/kafka/config_default && cp /opt/kafka/config/* /opt/kafka/config_default/

RUN chmod a+x /usr/bin/start-kafkaMirrorMaker.sh
WORKDIR $KAFKA_HOME

## Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)

CMD ["start-kafkaMirrorMaker.sh"]
