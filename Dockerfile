FROM makuk66/docker-solr:latest
MAINTAINER  Timur Ramazanov "t.ramazanov@statdata.kz"

USER root

run	apt-get -y update
run	apt-get -y install python-pip supervisor
run pip install mongo-connector

add ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
add ./solr.conf /etc/supervisor/conf.d/solr.conf
add ./start-solr-node.sh /opt/solr/bin/start-solr-node.sh
add ./mongo-connector.sh /opt/solr/bin/mongo-connector.sh

run chmod a+x /opt/solr/bin/start-solr-node.sh
run chmod a+x /opt/solr/bin/mongo-connector.sh

CMD "/usr/bin/supervisord"
