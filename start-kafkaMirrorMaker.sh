#!/bin/bash

cp /opt/kafka/config_default/* /opt/kafka/config/

cat /opt/kafka/config/consumer.properties.template | sed \
  -e "s|{{CONSUMER_BOOTSTRAP_SERVERS}}|${CONSUMER_BOOTSTRAP_SERVERS:-localhost:9092}|g" \
  -e "s|{{CONSUMER_GROUP_ID}}|${CONSUMER_GROUP_ID:-test-consumer-group}|g" \
  -e "s|{{CONSUMER_CLIENT_ID}}|${CONSUMER_CLIENT_ID:-test-consumer-group}|g" \
  -e "s|{{CONSUMER_EXCLUDE_INTERNAL_TOPICS}}|${CONSUMER_EXCLUDE_INTERNAL_TOPICS:-true}|g" \
  -e "s|{{CONSUMER_AUTO_OFFSET_RESET}}|${CONSUMER_AUTO_OFFSET_RESET:-latest}|g" \
   > /opt/kafka/config/consumer.properties

cat /opt/kafka/config/producer.properties.template | sed \
  -e "s|{{PRODUCER_BOOTSTRAP_SERVERS}}|${PRODUCER_BOOTSTRAP_SERVERS}|g" \
  -e "s|{{PRODUCER_COMPRESSION_TYPE}}|${PRODUCER_COMPRESSION_TYPE:-none}|g" \
  -e "s|{{PRODUCER_ACKS}}|${PRODUCER_ACKS:-1}|g" \
  -e "s|{{PRODUCER_BATCH_SIZE}}|${PRODUCER_BATCH_SIZE:-16384}|g" \
  -e "s|{{PRODUCER_CLIENT_ID}}|${PRODUCER_CLIENT_ID:-test-producer-group}|g" \
   > /opt/kafka/config/producer.properties

echo "Starting Kafka MirrorMaker"
exec bin/kafka-mirror-maker.sh --consumer.config  /opt/kafka/config/consumer.properties  --producer.config  /opt/kafka/config/producer.properties --num.streams "${NUM_STREAMS}" --whitelist "${WHITELIST}"
