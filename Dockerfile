FROM java:8u111-jre

ARG HIVE_VERSION=2.1.1
ADD https://goodrain-pkg.oss-cn-shanghai.aliyuncs.com/pkg/bigdata/apache-hive-${HADOOP_VERSION}-bin.tar.gz /usr/local



ENV HIVE_HOME=/usr/local/hive \
    PATH=${PATH}:${HIVE_HOME}/bin

RUN \
  cd /usr/local && ln -s ./apache-hive-${HIVE_VERSION}-bin have

ADD https://goodrain-pkg.oss-cn-shanghai.aliyuncs.com/pkg/mysql-connector/mysql-connector-j-8.0.32.jar ${HIVE_HOME}/lib
WORKDIR $HIVE_HOME


EXPOSE  9083 9084

CMD [ "/bin/bash", "/tmp/hadoop-config/bootstrap.sh", "-d" ]
