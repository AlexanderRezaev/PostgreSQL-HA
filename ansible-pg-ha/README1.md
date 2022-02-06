```
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
```
