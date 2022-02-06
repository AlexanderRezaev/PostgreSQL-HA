zk_patroni=$(/opt/zookeeper/bin/zkCli.sh -server 127.0.0.1:{{ zookeeper_clientPort }} <<EOF
ls {{ patroni_namespace }}
quit
EOF
)
echo -e ${zk_patroni} | sed 's/.*ls \{{ patroni_namespace }} \[//' | sed 's/] \[zk: 127.0.0.1.*//' | sed 's/zk: 127.0.0.1.*//'
