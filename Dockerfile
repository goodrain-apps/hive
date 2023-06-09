FROM java:8u111-jre

ARG HIVE_VERSION=4.0.0-alpha-2
ARG HADOOP_VERSION=3.0.0

ENV HIVE_HOME=/usr/local/hive \
    HADOOP_HOME=/usr/local/hadoop \
    HADOOP_PREFIX=/usr/local/hadoop \
    HADOOP_COMMON_HOME=/usr/local/hadoop \
    HADOOP_HDFS_HOME=/usr/local/hadoop \
    HADOOP_MAPRED_HOME=/usr/local/hadoop \
    HADOOP_YARN_HOME=/usr/local/hadoop \
    HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop \
    YARN_CONF_DIR=/usr/local/hadoop/etc/hadoop \
    PATH=${PATH}:${HIVE_HOME}/bin:${HADOOP_HOME}/bin

RUN curl https://goodrain-pkg.oss-cn-shanghai.aliyuncs.com/pkg/bigdata/apache-hive-${HIVE_VERSION}-bin.tar.gz -o /tmp/hive.tar.gz && \
    curl https://goodrain-pkg.oss-cn-shanghai.aliyuncs.com/pkg/bigdata/hadoop-${HADOOP_VERSION}.tar.gz -o /tmp/hadoop.tar.gz && \
    curl https://goodrain-pkg.oss-cn-shanghai.aliyuncs.com/pkg/mysql-connector/mysql-connector-j-8.0.32.jar -o /tmp/mysql-connector-j-8.0.32.jar && \
    tar xzf /tmp/hive.tar.gz -C  /usr/local && \
    tar xzf /tmp/hadoop.tar.gz  -C  /usr/local && \
    cd /usr/local && ln -s ./apache-hive-${HIVE_VERSION}-bin hive && ln -s ./hadoop-${HADOOP_VERSION} hadoop && \
    mv /tmp/mysql-connector-j-8.0.32.jar ${HIVE_HOME}/lib && \
    rm -rf /tmp/*.tar.gz

ADD bootstrap.sh /tmp/hadoop-config/bootstrap.sh
ADD etc $HIVE_HOME/etc
WORKDIR $HIVE_HOME


EXPOSE  9083 9084

ENTRYPOINT [ "/tmp/hadoop-config/bootstrap.sh"]
CMD [ "-d" ]
