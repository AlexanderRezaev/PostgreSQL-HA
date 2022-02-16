Установка с помощью ANSIBLE

#подготовка работы ansible. заполнение .ssh/known_hosts и выполнение ssh-copy-id
ansible-playbook -i inv_pg_hosts1 ssh-known_hosts.yml
ansible-playbook -i inv_pg_hosts1 ssh-copy-id.yml

#проверка доступности серверов перед установкой с помощью ansible
ansible dcs_cluster -i inv_pg_hosts1 -m ping

#установка DCS (Distributed Configuration Store) для patroni. Или etcd3, или zookeeper
#ansible-playbook -i inv_pg_hosts1 --tags zookeeper_install pgcluster1.yml
ansible-playbook -i inv_pg_hosts1 --tags etcd3_install pgcluster1.yml

#проверка доступности серверов перед установкой с помощью ansible
ansible postgresql_cluster -i inv_pg_hosts1 -m ping

#установка postgresql
ansible-playbook -i inv_pg_hosts1 --tags postgres_install pgcluster1.yml

#настройка postgresql
ansible-playbook -i inv_pg_hosts1 --tags postgres_preset pgcluster1.yml

#установка pgagent, pgbouncer, pgpool
ansible-playbook -i inv_pg_hosts1 --tags pgagent_install pgcluster1.yml
ansible-playbook -i inv_pg_hosts1 --tags pgbouncer_install pgcluster1.yml
ansible-playbook -i inv_pg_hosts1 --tags pgpool_install pgcluster1.yml

#установка patroni
ansible-playbook -i inv_pg_hosts1 --tags patroni_install pgcluster1.yml

#конфигурирование кластера postgresql с синхронной репликацией
ansible-playbook -i inv_pg_hosts1 --tags patroni_config_sync pgcluster1.yml

#инициализация кластера
ansible-playbook -i inv_pg_hosts1 --tags patroni_init pgcluster1.yml

#установка в кластер pg_profile extension
ansible-playbook -i inv_pg_hosts1 --tags pg_profile_install pgcluster1.yml

#настройка шифрации сетевого трафика между серверами кластера
ansible-playbook -i inv_pg_hosts1 --tags ipsec_install pgcluster1.yml
