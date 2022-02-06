mkdir -p /root/packages/postgres/PG13
cd /root/packages/postgres/PG13

wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/postgresql13-13.4-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/postgresql13-contrib-13.4-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/postgresql13-devel-13.4-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/postgresql13-libs-13.4-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/postgresql13-plperl-13.4-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/postgresql13-server-13.4-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/pg_cron_13-1.4.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/pgagent_13-4.2.1-0.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/pgpool-II-13-4.1.4-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.4-x86_64/pgpool-II-13-extensions-4.1.4-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/pgbouncer-1.16.0-1.rhel8.x86_64.rpm

mkdir -p /root/packages/postgres/PG14
cd /root/packages/postgres/PG14

wget https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.5-x86_64/postgresql14-14.1-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.5-x86_64/postgresql14-contrib-14.1-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.5-x86_64/postgresql14-devel-14.1-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.5-x86_64/postgresql14-libs-14.1-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.5-x86_64/postgresql14-plperl-14.1-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.5-x86_64/postgresql14-server-14.1-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.5-x86_64/pg_cron_14-1.4.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.5-x86_64/pgagent_14-4.2.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/pgpool-II-4.3.0-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.5-x86_64/pgpool-II-pg14-extensions-4.3.0-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/pgbouncer-1.16.1-2.rhel8.x86_64.rpm

#

mkdir -p /root/packages/patroni/2.1.1
cd /root/packages/patroni/2.1.1

wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/patroni-zookeeper-2.1.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/pgbouncer-1.16.0-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.1-x86_64/python3-etcd-0.4.5-20.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/python3-etcd-0.4.5-20.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/patroni-2.1.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/patroni-aws-2.1.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/patroni-etcd-2.1.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/patroni-zookeeper-2.1.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.1-x86_64/python3-boto-2.49.0-7.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.1-x86_64/python3-kazoo-2.8.0-1.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.1-x86_64/python3-cdiff-1.0-1.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.1-x86_64/python3-ydiff-1.2-10.rhel8.noarch.rpm

mkdir -p /root/packages/patroni/2.1.2
cd /root/packages/patroni/2.1.2
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/python3-psycopg3-3.0.7-1.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/python3-boto-2.49.0-7.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/python3-cdiff-1.0-1.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/python3-kazoo-2.8.0-1.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/python3-ydiff-1.2-10.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/python3-etcd-0.4.5-20.rhel8.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/patroni-2.1.2-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/patroni-aws-2.1.2-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/patroni-etcd-2.1.2-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/patroni-zookeeper-2.1.2-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/pgbouncer-1.16.1-2.rhel8.x86_64.rpm


#OracleLinux
#https://yum.oracle.com/repo/OracleLinux/OL8/developer/x86_64/index.html
wget https://yum.oracle.com/repo/OracleLinux/OL8/developer/x86_64/getPackage/python3-certifi-2018.10.15-5.0.1.el8.noarch.rpm

#

wget https://github.com/zubkov-andrei/pg_profile/releases/download/0.3.4/pg_profile--0.3.4.tar.gz
wget https://github.com/zubkov-andrei/pg_profile/releases/download/0.3.6/pg_profile--0.3.6.tar.gz

#

mkdir -p /root/packages/patroni/pip3/2.1.1
cd /root/packages/patroni/pip3/2.1.1
pip3 download --only-binary :none --retries 1 patroni[zookeeper,aws]==2.1.1
pip3 download --only-binary :none --retries 1 patroni[etcd,aws]==2.1.1

#

mkdir -p /root/packages/patroni/pip3/2.1.2
cd /root/packages/patroni/pip3/2.1.2
pip3 download --only-binary :none --retries 1 patroni[zookeeper,aws]==2.1.2
pip3 download --only-binary :none --retries 1 patroni[etcd,aws]==2.1.2

#

