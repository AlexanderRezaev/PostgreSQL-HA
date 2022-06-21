ansible-playbook -i inv_pg_hosts1 ssh-known_hosts.yml
ansible-playbook -i inv_pg_hosts1 ssh-copy-id.yml

#ansible c8-h1 -i inv_pg_hosts1 -m ansible.builtin.setup |grep '_os'

ansible dcs_cluster -i inv_pg_hosts1 -m ping
ansible-playbook -i inv_pg_hosts1 --tags cgroups_install pgcluster1.yml
#ansible-playbook -i inv_pg_hosts1 --tags zookeeper_install pgcluster1.yml
ansible-playbook -i inv_pg_hosts1 --tags etcd3_install pgcluster1.yml

ansible postgresql_cluster -i inv_pg_hosts1 -m ping

ansible-playbook -i inv_pg_hosts1 --tags postgres_install pgcluster1.yml

ansible-playbook -i inv_pg_hosts1 --tags postgres_preset pgcluster1.yml

ansible-playbook -i inv_pg_hosts1 --tags pgagent_install pgcluster1.yml
ansible-playbook -i inv_pg_hosts1 --tags pgbouncer_install pgcluster1.yml
ansible-playbook -i inv_pg_hosts1 --tags pgpool_install pgcluster1.yml

#ansible patroni_cluster -i inv_pg_hosts1 -m ping

ansible-playbook -i inv_pg_hosts1 --tags patroni_install pgcluster1.yml
ansible-playbook -i inv_pg_hosts1 --tags patroni_config_sync pgcluster1.yml

#ansible-playbook -i inv_pg_hosts1 --tags patroni_config_async pgcluster1.yml

ansible-playbook -i inv_pg_hosts1 --tags patroni_init pgcluster1.yml

ansible-playbook -i inv_pg_hosts1 --tags pg_profile_install pgcluster1.yml

ansible-playbook -i inv_pg_hosts1 --tags ipsec_install pgcluster1.yml

---------------------------------------------------------------------------------

patronictl list
+ Cluster: c8-cls (7003250879094942687) --+----+-----------+
| Member | Host       | Role    | State   | TL | Lag in MB |
+--------+------------+---------+---------+----+-----------+
| c8-h1  | c8-h1:5434 | Leader  | running |  2 |           |
| c8-h2  | c8-h2:5434 | Replica | running |  2 |         0 |
| c8-h3  | c8-h3:5434 | Replica | running |  2 |         0 |
+--------+------------+---------+---------+----+-----------+

---------------------------------------------------------------------------------

проверка, что именно кворум
(это только при patroni_replica_synchronous: false)

sudo -iu postgres psql -p 5434 -c "SELECT application_name,client_addr,usename,state,sync_state,sync_priority,write_lag,flush_lag,replay_lag FROM pg_stat_replication;"

 application_name |  client_addr   |  usename   |   state   | sync_state | sync_priority | write_lag | flush_lag | replay_lag 
------------------+----------------+------------+-----------+------------+---------------+-----------+-----------+------------
 o8-h3            | 172.27.172.205 | clsreplica | streaming | quorum     |             1 |           |           | 
 o8-h1            | 172.27.172.203 | clsreplica | streaming | quorum     |             1 |           |           | 

---------------------------------------------------------------------------------

tar -cvzf ansible-postgres-20210215.tar.gz ansible-postgres

---------------------------------------------------------------------------------

шифрация всего сетевого трафика между серверами

ansible-playbook -i inv_pg_hosts1 ipsec_encrypt.yml

ipsec whack --trafficstatus
006 #4: "conn_172.27.172.144_172.27.172.145", type=ESP, add_time=1630572998, inBytes=2413, outBytes=1738, id='@c8-h2.lab.local'
006 #6: "conn_172.27.172.144_172.27.172.146", type=ESP, add_time=0, inBytes=0, outBytes=179, id='@c8-h3.lab.local'
006 #7: "conn_172.27.172.144_172.27.172.146", type=ESP, add_time=1630572998, inBytes=234, outBytes=0, id='@c8-h3.lab.local'

ESP - Encapsulating Security Payload

---------------------------------------------------------------------------------

настроек нет пока
systemd-cgls --no-pager
find /sys/fs/cgroup -name "zookeeper*"
find /sys/fs/cgroup -name "postgres*"

---------------------------------------------------------------------------------
