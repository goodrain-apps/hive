FROM java:8u111-jre

ARG HIVE_VERSION=2.1.1
ADD apache-hive-${HIVE_VERSION}-bin.tar.gz /usr/local



ENV HIVE_HOME=/usr/local/hive \
    PATH=${PATH}:${HIVE_HOME}/bin

RUN \
  cd /usr/local && ln -s ./apache-hive-${HIVE_VERSION}-bin hive

ADD mysql-connector-j-8.0.32.jar ${HIVE_HOME}/lib
ADD bootstrap.sh /tmp/hadoop-config/bootstrap.sh
COPY etc $HIVE_HOME
WORKDIR $HIVE_HOME


EXPOSE  9083 9084

ENTRYPOINT [ "/tmp/hadoop-config/bootstrap.sh"]
CMD [ "-d" ]
