<B>Установка с помощью ANSIBLE</B>

<B>#Тестировалось на Rocky (CentOS) Linux 8.5, RedHat Linux 8.5, Oracle Linux 8.5</B>

<B>#подготовка работы ansible. заполнение .ssh/known_hosts и выполнение ssh-copy-id</B><BR>
ansible-playbook -i inv_pg_hosts1 ssh-known_hosts.yml<BR>
ansible-playbook -i inv_pg_hosts1 ssh-copy-id.yml<BR>

<B>#проверка доступности серверов перед установкой с помощью ansible</B><BR>
ansible dcs_cluster -i inv_pg_hosts1 -m ping<BR>

<B>#установка DCS (Distributed Configuration Store) для patroni. Или etcd3, или zookeeper</B><BR>
#ansible-playbook -i inv_pg_hosts1 --tags zookeeper_install pgcluster1.yml<BR>
ansible-playbook -i inv_pg_hosts1 --tags etcd3_install pgcluster1.yml<BR>

<B>#проверка доступности серверов перед установкой с помощью ansible</B><BR>
ansible postgresql_cluster -i inv_pg_hosts1 -m ping<BR>

<B>#установка postgresql</B><BR>
ansible-playbook -i inv_pg_hosts1 --tags postgres_install pgcluster1.yml<BR>

<B>#настройка postgresql</B><BR>
ansible-playbook -i inv_pg_hosts1 --tags postgres_preset pgcluster1.yml<BR>

<B>#установка pgagent, pgbouncer, pgpool</B><BR>
ansible-playbook -i inv_pg_hosts1 --tags pgagent_install pgcluster1.yml<BR>
ansible-playbook -i inv_pg_hosts1 --tags pgbouncer_install pgcluster1.yml<BR>
ansible-playbook -i inv_pg_hosts1 --tags pgpool_install pgcluster1.yml<BR>

<B>#установка patroni</B><BR>
ansible-playbook -i inv_pg_hosts1 --tags patroni_install pgcluster1.yml<BR>

<B>#конфигурирование кластера postgresql с синхронной репликацией</B><BR>
ansible-playbook -i inv_pg_hosts1 --tags patroni_config_sync pgcluster1.yml<BR>

<B>#инициализация кластера</B><BR>
ansible-playbook -i inv_pg_hosts1 --tags patroni_init pgcluster1.yml<BR>

<B>#установка в кластер pg_profile extension</B><BR>
ansible-playbook -i inv_pg_hosts1 --tags pg_profile_install pgcluster1.yml<BR>

<B>#настройка шифрации сетевого трафика между серверами кластера</B><BR>
ansible-playbook -i inv_pg_hosts1 --tags ipsec_install pgcluster1.yml<BR>
