ls -la /dev/sd*
vgs --units m -o vg_name,pv_name,pv_size,pv_free
lvs --units m -o vg_name,lv_name,origin,lv_size,data_percent,mirror_log,devices
pvs --units m -o pv_name,pv_size,pv_free

# fdisk /dev/sdb
# fdisk /dev/sdc
# fdisk /dev/sdd
pvcreate /dev/sdb1
pvcreate /dev/sdc1
pvcreate /dev/sdd1
vgcreate postgresql_data_vg /dev/sdb1
vgcreate postgresql_wal_vg /dev/sdc1
vgcreate dcs_vg /dev/sdd1
lvcreate -n pg_data -l 100%FREE postgresql_data_vg
lvcreate -n pg_wal -l 100%FREE postgresql_wal_vg
lvcreate -n dcs -l 100%FREE dcs_vg

# mkfs.ext4 /dev/postgresql_data_vg/pg_data
# mkfs.ext4 /dev/postgresql_wal_vg/pg_wal

mkfs.xfs /dev/postgresql_data_vg/pg_data
mkfs.xfs /dev/postgresql_wal_vg/pg_wal
mkfs.ext4 /dev/dcs_vg/dcs

mkdir /pg_data
mkdir /pg_wal
mkdir /dcs

cat /etc/fstab | nocomments
nano /etc/fstab

/dev/postgresql_data_vg/pg_data /pg_data xfs defaults        0 0
/dev/postgresql_wal_vg/pg_wal /pg_wal ext4 rw,noatime,async,barrier=0,data=writeback,commit=60 0 0
/dev/dcs_vg/dcs /dcs ext4 rw,noatime,async,barrier=0,data=writeback,commit=60 0 0

mount -a

df -hT | grep -v "devtmpfs\|tmpfs\|squashfs"
Filesystem                             Type      Size  Used Avail Use% Mounted on
/dev/sda1                              xfs      1014M  215M  800M  22% /boot
/dev/mapper/rl-root                    xfs        14G  2.0G   12G  15% /
/dev/mapper/postgresql_wal_vg-pg_wal   xfs       8.0G   90M  7.9G   2% /pg_wal
/dev/mapper/postgresql_data_vg-pg_data xfs       8.0G   90M  7.9G   2% /pg_data
/dev/mapper/dcs_vg-dcs                 ext4      3.9G   16M  3.7G   1% /dcs

vgs --units m -o vg_name,pv_name,pv_size,pv_free
  VG                 PV         PSize     PFree
  rl                 /dev/sda2  15356.00m    0m
  postgresql_data_vg /dev/sdb1   8188.00m    0m
  postgresql_wal_vg  /dev/sdc1   8188.00m    0m
  dcs_vg             /dev/sdd1   4092.00m    0m

lvs --units m -o vg_name,lv_name,origin,lv_size,data_percent,mirror_log,devices
  VG                 LV      Origin LSize     Data%  Log Devices       
  rl                 root           13716.00m            /dev/sda2(410)
  rl                 swap            1640.00m            /dev/sda2(0)  
  postgresql_data_vg pg_data         8188.00m            /dev/sdb1(0)  
  postgresql_wal_vg  pg_wal          8188.00m            /dev/sdc1(0)  
  dcs_vg             dcs             4092.00m            /dev/sdd1(0)  

После ansible-postgres

ls -la /var/lib/pgsql/
total 32
drwxr-x---   4 postgres postgres  175 Sep  2 18:42 .
drwxr-xr-x. 40 root     root     4096 Sep  2 18:14 ..
drwx------   2 postgres postgres    6 Sep  2 18:16 13
-rwxr-x---   1 postgres postgres 1803 Sep  2 18:20 analyze.sh
-rwx------   1 postgres postgres 1852 Sep  2 18:20 AutoShutdownPG.sh
drwx------   2 postgres postgres   62 Sep  2 18:20 backups
-rwx------   1 postgres postgres  266 Sep  2 18:14 .bash_profile
lrwxrwxrwx   1 root     root       13 Sep  2 18:16 data -> /pg_data/data
-rwx------   1 postgres postgres  907 Sep  2 18:20 DiskUsage.sh
-rwx------   1 postgres postgres 5401 Sep  2 18:20 SendLocks.sh
-rwxr-x---   1 postgres postgres 1812 Sep  2 18:20 vacuum.sh
lrwxrwxrwx   1 root     root       11 Sep  2 18:16 wal -> /pg_wal/wal

ls -la /var/lib/pgsql/13/
total 0
drwx------ 2 postgres postgres   6 Sep  2 18:16 .
drwxr-x--- 4 postgres postgres 175 Sep  2 18:42 ..

ls -la /var/lib/pgsql/backups/
total 28
drwx------ 2 postgres postgres    62 Sep  2 18:20 .
drwxr-x--- 4 postgres postgres   175 Sep  2 18:42 ..
-rw-r--r-- 1 postgres postgres  5459 Sep  2 18:20 pgagent.sql
-rw-r--r-- 1 postgres postgres  2848 Sep  2 18:20 pgedb.sql
-rw-r--r-- 1 postgres postgres 12579 Sep  2 18:20 pglog.sql

grep -RP 'postgresql_.*_vg' . | grep -v PREPARE
./roles/install-postgres/tasks/install.yml:# нужно смонтировать postgresql_root_dir=/var/lib/pgsql на диск /dev/postgresql_data_vg/pg_data
./roles/install-postgres/defaults/main.yml:postgresql_data_dev: "/dev/postgresql_data_vg/pg_data"
./roles/install-postgres/defaults/main.yml:postgresql_wal_dev:  "/dev/postgresql_wal_vg/pg_wal"


-------------------------------------------------------------------------------------------------------------------------------------------------------

ls -R /root/packages/
/root/packages/:
etcd3  patroni  postgres  zookeeper

/root/packages/etcd3:
etcd-v3.3.25-linux-amd64.tar.gz

/root/packages/patroni:
2.1.1  pip3  readme.md

/root/packages/patroni/2.1.1:
patroni-2.1.1-1.rhel8.x86_64.rpm       patroni-zookeeper-2.1.1-1.rhel8.x86_64.rpm  python3-certifi-2018.10.15-5.0.1.el8.noarch.rpm  python3-psycopg2-2.8.6-1.rhel8.x86_64.rpm
patroni-aws-2.1.1-1.rhel8.x86_64.rpm   python3-boto-2.49.0-7.rhel8.noarch.rpm      python3-etcd-0.4.5-20.rhel8.noarch.rpm           python3-ydiff-1.2-10.rhel8.noarch.rpm
patroni-etcd-2.1.1-1.rhel8.x86_64.rpm  python3-cdiff-1.0-1.rhel8.noarch.rpm        python3-kazoo-2.8.0-1.rhel8.noarch.rpm

/root/packages/patroni/pip3:
2.1.1  readme.md

/root/packages/patroni/pip3/2.1.1:
boto-2.49.0-py2.py3-none-any.whl           patroni-2.1.1-py3-none-any.whl              PyYAML-5.4.1-cp36-cp36m-manylinux1_x86_64.whl  ydiff-1.2.tar.gz
click-8.0.2-py3-none-any.whl               prettytable-2.2.1-py3-none-any.whl          six-1.16.0-py2.py3-none-any.whl                zipp-3.6.0-py3-none-any.whl
dnspython-2.1.0-py3-none-any.whl           psutil-5.8.0.tar.gz                         typing_extensions-3.10.0.2-py3-none-any.whl
importlib_metadata-4.8.1-py3-none-any.whl  python_dateutil-2.8.2-py2.py3-none-any.whl  urllib3-1.26.7-py2.py3-none-any.whl
kazoo-2.8.0-py2.py3-none-any.whl           python-etcd-0.4.5.tar.gz                    wcwidth-0.2.5-py2.py3-none-any.whl

/root/packages/postgres:
PG10  PG12  PG13  PG14

/root/packages/postgres/PG10:
pgagent_10-4.2.1-0.rhel8.x86_64.rpm    pgpool-II-10-extensions-4.1.4-1.rhel8.x86_64.rpm   postgresql10-devel-10.18-1PGDG.rhel8.x86_64.rpm
pgbouncer-1.16.0-1.rhel8.x86_64.rpm    pg_profile--0.3.4.tar.gz                           postgresql10-libs-10.18-1PGDG.rhel8.x86_64.rpm
pg_cron_10-1.4.1-1.rhel8.x86_64.rpm    postgresql10-10.18-1PGDG.rhel8.x86_64.rpm          postgresql10-plperl-10.18-1PGDG.rhel8.x86_64.rpm
pgpool-II-10-4.1.4-1.rhel8.x86_64.rpm  postgresql10-contrib-10.18-1PGDG.rhel8.x86_64.rpm  postgresql10-server-10.18-1PGDG.rhel8.x86_64.rpm

/root/packages/postgres/PG12:
pgagent_12-4.2.1-0.rhel8.x86_64.rpm    pgpool-II-12-extensions-4.1.4-1.rhel8.x86_64.rpm  postgresql12-devel-12.8-1PGDG.rhel8.x86_64.rpm
pgbouncer-1.16.0-1.rhel8.x86_64.rpm    pg_profile--0.3.4.tar.gz                          postgresql12-libs-12.8-1PGDG.rhel8.x86_64.rpm
pg_cron_12-1.4.1-1.rhel8.x86_64.rpm    postgresql12-12.8-1PGDG.rhel8.x86_64.rpm          postgresql12-plperl-12.8-1PGDG.rhel8.x86_64.rpm
pgpool-II-12-4.1.4-1.rhel8.x86_64.rpm  postgresql12-contrib-12.8-1PGDG.rhel8.x86_64.rpm  postgresql12-server-12.8-1PGDG.rhel8.x86_64.rpm

/root/packages/postgres/PG13:
pgagent_13-4.2.1-0.rhel8.x86_64.rpm    pgpool-II-13-extensions-4.1.4-1.rhel8.x86_64.rpm  postgresql13-devel-13.4-1PGDG.rhel8.x86_64.rpm
pgbouncer-1.16.0-1.rhel8.x86_64.rpm    pg_profile--0.3.4.tar.gz                          postgresql13-libs-13.4-1PGDG.rhel8.x86_64.rpm
pg_cron_13-1.4.1-1.rhel8.x86_64.rpm    postgresql13-13.4-1PGDG.rhel8.x86_64.rpm          postgresql13-plperl-13.4-1PGDG.rhel8.x86_64.rpm
pgpool-II-13-4.1.4-1.rhel8.x86_64.rpm  postgresql13-contrib-13.4-1PGDG.rhel8.x86_64.rpm  postgresql13-server-13.4-1PGDG.rhel8.x86_64.rpm

/root/packages/postgres/PG14:
pgagent_14-4.2.1-1.rhel8.x86_64.rpm  pgpool-II-pg14-extensions-4.3.0-1.rhel8.x86_64.rpm  postgresql14-devel-14.1-1PGDG.rhel8.x86_64.rpm
pgbouncer-1.16.1-2.rhel8.x86_64.rpm  pg_profile--0.3.4.tar.gz                            postgresql14-libs-14.1-1PGDG.rhel8.x86_64.rpm
pg_cron_14-1.4.1-1.rhel8.x86_64.rpm  postgresql14-14.1-1PGDG.rhel8.x86_64.rpm            postgresql14-plperl-14.1-1PGDG.rhel8.x86_64.rpm
pgpool-II-4.3.0-1.rhel8.x86_64.rpm   postgresql14-contrib-14.1-1PGDG.rhel8.x86_64.rpm    postgresql14-server-14.1-1PGDG.rhel8.x86_64.rpm

/root/packages/zookeeper:
apache-zookeeper-3.5.8-bin.tar.gz  apache-zookeeper-3.5.9-bin.tar.gz

-------------------------------------------------------------------------------------------------------------------------------------------------------

wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/pgbouncer-1.16.0-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/pg_cron_10-1.4.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/pgagent_10-4.2.1-0.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/pgpool-II-10-4.1.4-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/pgpool-II-10-extensions-4.1.4-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/postgresql10-10.18-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/postgresql10-contrib-10.18-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/postgresql10-devel-10.18-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/postgresql10-libs-10.18-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/postgresql10-plperl-10.18-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8.4-x86_64/postgresql10-server-10.18-1PGDG.rhel8.x86_64.rpm

wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.4-x86_64/pgbouncer-1.16.0-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/pg_cron_12-1.4.1-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/pgagent_12-4.2.1-0.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/pgpool-II-12-4.1.4-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/pgpool-II-12-extensions-4.1.4-1.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/postgresql12-12.8-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/postgresql12-contrib-12.8-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/postgresql12-devel-12.8-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/postgresql12-libs-12.8-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/postgresql12-plperl-12.8-1PGDG.rhel8.x86_64.rpm
wget https://download.postgresql.org/pub/repos/yum/12/redhat/rhel-8.4-x86_64/postgresql12-server-12.8-1PGDG.rhel8.x86_64.rpm

wget https://download.postgresql.org/pub/repos/yum/common/redhat/rhel-8.5-x86_64/pgpool-II-4.3.0-1.rhel8.x86_64.rpm
-------------------------------------------------------------------------------------------------------------------------------------------------------

wget https://github.com/etcd-io/etcd/releases/download/v3.2.25/etcd-v3.2.25-linux-amd64.tar.gz
wget https://github.com/etcd-io/etcd/releases/download/v3.4.17/etcd-v3.4.17-linux-amd64.tar.gz

-------------------------------------------------------------------------------------------------------------------------------------------------------

wget https://dlcdn.apache.org/zookeeper/zookeeper-3.7.0/apache-zookeeper-3.7.0-bin.tar.gz
wget https://mirror.linux-ia64.org/apache/zookeeper/zookeeper-3.6.3/apache-zookeeper-3.6.3-bin.tar.gz

-------------------------------------------------------------------------------------------------------------------------------------------------------
