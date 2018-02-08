if [ -z "${ZK_HOST}" ]; then
	bin/solr start -p 8983 -f
else
	cp -r /opt/solr/example /opt/solr/node
	mv /opt/solr/node/solr/collection1 /opt/solr/node/solr/${SOLR_CORE_NAME}
	rm /opt/solr/node/solr/${SOLR_CORE_NAME}/core.properties
	echo "name=${SOLR_CORE_NAME}" >> /opt/solr/node/solr/${SOLR_CORE_NAME}/core.properties

	if [ -d /data ]; then
		cp /data/solrconfig.xml /opt/solr/node/solr/${SOLR_CORE_NAME}/conf/solrconfig.xml
		cp /data/schema.xml /opt/solr/node/solr/${SOLR_CORE_NAME}/conf/schema.xml
	fi

	cd /opt/solr/node

	if [ -n "${ZK_HOST}" ] && [ "${IS_MASTER}"=="true" ]; then
		java -DzkClientTimeout=15000 -Djetty.port=8983 -DsocketTimeout=1000 -DconnTimeout=1000 -Dbootstrap_confdir=./solr/${SOLR_CORE_NAME}/conf -Dcollection.configName=${SOLR_CORE_NAME} -DzkHost=${ZK_HOST}:${ZK_PORT} -jar start.jar
	else
		java -DzkClientTimeout=15000 -Djetty.port=8983 -DsocketTimeout=1000 -DconnTimeout=1000 -DzkHost=${ZK_HOST}:${ZK_PORT} -jar start.jar
	fi

fi

