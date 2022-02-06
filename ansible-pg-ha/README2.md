```
ansible-playbook -i inv_pg_hosts2 ssh-known_hosts.yml
ansible-playbook -i inv_pg_hosts2 ssh-copy-id.yml

ansible dcs_cluster -i inv_pg_hosts2 -m ping
ansible-playbook -i inv_pg_hosts2 --tags cgroups_install pgcluster2.yml
ansible-playbook -i inv_pg_hosts2 --tags zookeeper_install pgcluster2.yml
#ansible-playbook -i inv_pg_hosts2 --tags etcd3_install pgcluster2.yml

ansible postgresql_cluster -i inv_pg_hosts2 -m ping

ansible-playbook -i inv_pg_hosts2 --tags postgres_install pgcluster2.yml

ansible-playbook -i inv_pg_hosts2 --tags postgres_preset pgcluster2.yml

ansible-playbook -i inv_pg_hosts2 --tags pgagent_install pgcluster2.yml
ansible-playbook -i inv_pg_hosts2 --tags pgbouncer_install pgcluster2.yml
ansible-playbook -i inv_pg_hosts2 --tags pgpool_install pgcluster2.yml

#ansible patroni_cluster -i inv_pg_hosts2 -m ping

ansible-playbook -i inv_pg_hosts2 --tags patroni_install pgcluster2.yml
ansible-playbook -i inv_pg_hosts2 --tags patroni_config_sync pgcluster2.yml

#ansible-playbook -i inv_pg_hosts2 --tags patroni_config_async pgcluster2.yml

ansible-playbook -i inv_pg_hosts2 --tags patroni_init pgcluster2.yml

ansible-playbook -i inv_pg_hosts2 --tags pg_profile_install pgcluster2.yml
ansible-playbook -i inv_pg_hosts2 --tags ipsec_install pgcluster2.yml
```
cat README2.md | grep -v '```' | nocomments
