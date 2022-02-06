#!/bin/bash
ICFGADDR="{{ patroni_cluster_ip }}"
ICFGMASK="{{ ansible_host_netmask.stdout | ipaddr('prefix') }}"
ICFGDEV="{{ ansible_default_ipv4.interface }}"
PGPORT="{{ postgresql_port }}"
PATRONI_LOG="{{ patroni_log }}"
echo "$(date '+%Y-%m-%d %H:%M:%S'): [$1] callback triggered by [$0] on $HOSTNAME [$2], [$3]" >>${PATRONI_LOG} 2>&1
echo "nothing" >>${PATRONI_LOG} 2>&1
exit 0
