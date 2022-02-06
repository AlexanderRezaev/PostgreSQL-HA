ansible-playbook -i inv_pg_hosts3 ssh-known_hosts.yml
ansible-playbook -i inv_pg_hosts3 ssh-copy-id.yml

ansible dcs_cluster -i inv_pg_hosts3 -m ping
ansible-playbook -i inv_pg_hosts3 --tags cgroups_install pgcluster3.yml
#ansible-playbook -i inv_pg_hosts1 --tags zookeeper_install pgcluster1.yml
ansible-playbook -i inv_pg_hosts3 --tags etcd3_install pgcluster3.yml

ansible postgresql_cluster -i inv_pg_hosts3 -m ping

ansible-playbook -i inv_pg_hosts3 --tags postgres_install pgcluster3.yml

ansible-playbook -i inv_pg_hosts3 --tags postgres_preset pgcluster3.yml

ansible-playbook -i inv_pg_hosts3 --tags pgagent_install pgcluster3.yml
ansible-playbook -i inv_pg_hosts3 --tags pgbouncer_install pgcluster3.yml
ansible-playbook -i inv_pg_hosts3 --tags pgpool_install pgcluster3.yml

#ansible patroni_cluster -i inv_pg_hosts3 -m ping

ansible-playbook -i inv_pg_hosts3 --tags patroni_install pgcluster3.yml
ansible-playbook -i inv_pg_hosts3 --tags patroni_config_sync pgcluster3.yml

#ansible-playbook -i inv_pg_hosts3 --tags patroni_config_async pgcluster3.yml

ansible-playbook -i inv_pg_hosts3 --tags patroni_init pgcluster3.yml

ansible-playbook -i inv_pg_hosts3 --tags pg_profile_install pgcluster3.yml
ansible-playbook -i inv_pg_hosts3 --tags ipsec_install pgcluster3.yml
