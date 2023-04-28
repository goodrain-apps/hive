FROM java:8u111-jre

# Add native libs
ARG HIVE_VERSION=2.1.1
ADD https://goodrain-pkg.oss-cn-shanghai.aliyuncs.com/pkg/bigdata/apache-hive-${HADOOP_VERSION}-bin.tar.gz /usr/local


ENV HIVE_HOME=/usr/local/hive \
    PATH=${PATH}:${HIVE_HOME}/bin

RUN \
  cd /usr/local && ln -s ./apache-hive-${HIVE_VERSION}-bin have &&

WORKDIR $HIVE_HOME

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122
