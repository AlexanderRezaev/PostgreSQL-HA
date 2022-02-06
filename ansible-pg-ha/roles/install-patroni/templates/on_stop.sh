#!/bin/bash
ICFGADDR="{{ patroni_cluster_ip }}"
ICFGMASK="{{ ansible_host_netmask.stdout | ipaddr('prefix') }}"
ICFGDEV="{{ ansible_default_ipv4.interface }}"
PGPORT="{{ postgresql_port }}"
PATRONI_LOG="{{ patroni_log }}"
echo "$(date '+%Y-%m-%d %H:%M:%S'): [$1] callback triggered by [$0] on $HOSTNAME [$2], [$3]" >>${PATRONI_LOG} 2>&1
if [[ "$2" == "master" ]]; then
{% if install_pgagent|default(false)|bool == true %}
sudo /usr/bin/systemctl stop pgagent_{{ postgresql_version }} >>${PATRONI_LOG} 2>&1
{% endif %}
{% if install_pgbouncer|default(false)|bool == true %}
sudo /usr/bin/systemctl kill pgbouncer >>${PATRONI_LOG} 2>&1
{% endif %}
{% if install_pgpool|default(false)|bool == true and postgresql_version|int < 14 %}
sudo /usr/bin/systemctl stop pgpool-II-{{ postgresql_version }} >>${PATRONI_LOG} 2>&1
{% endif %}
{% if install_pgpool|default(false)|bool == true and postgresql_version|int >= 14 %}
sudo /usr/bin/systemctl stop pgpool-II >>${PATRONI_LOG} 2>&1
{% endif %}
{% if patroni_config_barman|default(false)|bool == true %}
#psql -p ${PGPORT} postgres -c "SELECT pg_drop_replication_slot('barman');" >>${PATRONI_LOG} 2>&1
{% endif %}
sudo /usr/sbin/ip address delete ${ICFGADDR}/${ICFGMASK} dev ${ICFGDEV} >>${PATRONI_LOG} 2>&1 && echo "cluster ip deleted" >>${PATRONI_LOG} 2>&1
sudo /usr/sbin/ip -s neigh flush all >>${PATRONI_LOG} 2>&1
exit 0
else
sudo /usr/sbin/ip -s neigh flush all >>${PATRONI_LOG} 2>&1
exit 0
fi
exit 0
