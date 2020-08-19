# Apache Kafka MirrorMaker running in Docker container

Configurable Docker image that executes Apache Kafka MirrorMaker


**Example**

docker build . --tag artifactory.cesaro.io/kafkamirrormaker:0.2
bin/kafka-mirror-maker --consumer.config  /opt/kafka/config/consumer.properties  --producer.config  /opt/kafka/config/producer.properties --num.streams=1 --whitelist "test1"

docker run --log-opt max-size=50m --log-driver=json-file -id \
--memory=“2g" --memory-reservation=“2g" \
--name kafka_mirrormaker \
-v /data/kafka/mirrormaker/logs:/opt/kafka/logs \
-v /data/kafka/mirrormaker/config:/opt/kafka/config \
-e KAFKA_HEAP_OPTS="-Xmx1G -Xms1G" \
-e KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:/opt/kafka/config/log4j.properties" \
-e NUM_STREAMS="1" \
-e WHITELIST="topic1" \
-e CONSUMER_BOOTSTRAP_SERVERS="<host1>:9092,<host2>:9092" \
-e CONSUMER_GROUP_ID="test-consumer-group" \
-e CONSUMER_CLIENT_ID="test-consumer-group" \
-e CONSUMER_EXCLUDE_INTERNAL_TOPICS="true" \
-e CONSUMER_AUTO_OFFSET_RESET="earliest" \
-e PRODUCER_BOOTSTRAP_SERVERS="<host3>:9092,<host4>:9092" \
-e PRODUCER_COMPRESSION_TYPE="none" \
-e PRODUCER_ACKS="1" \
-e PRODUCER_BATCH_SIZE="100" \
-e PRODUCER_CLIENT_ID="test-producer-group" \
-t artifactory.cesaro.io/kafkamirrormaker:0.1

