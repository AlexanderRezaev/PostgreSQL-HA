#!/bin/bash
# Configured by Ansible

if [ -n "$1" ]; then
pattern=$1
else
pattern=$(date +'%Y%m%d_%H%M')
fi

zk_path="{{ zookeeper_data }}"
zk_cfg="/etc/{{ zookeeper_service }}"
zk_bkp="{{ zookeeper_backup_home }}/{{ zookeeper_service }}"
zk_fz="/"
zk_rotation="60*24*{{ zookeeper_backup_rotation_days }}"

mkdir ${zk_bkp} 2>/dev/null 1>&1

sync; echo 3 > /proc/sys/vm/drop_caches

checkpath=${zk_path}
if [ $(stat -c%d "${checkpath}") != $(stat -c%d "${checkpath}/..") ]; then
  echo "${checkpath} is mounted"

  fsfreeze -f ${zk_fz}

  tar -cvzf ${zk_bkp}/zk_${pattern}_dat.tgz -P --no-recursion --files-from <(find ${zk_path} -not -path "${zk_path}/lost+found" -not -path "${zk_path}/zookeeper_server.pid")
  tar -cvzf ${zk_bkp}/zk_${pattern}_cfg.tgz ${zk_cfg} -P

  fsfreeze -u ${zk_fz}
else
  echo "${checkpath} is not mounted"

  tar -cvzf ${zk_bkp}/zk_${pattern}_dat.tgz -P --no-recursion --files-from <(find ${zk_path} -not -path "${zk_path}/lost+found" -not -path "${zk_path}/zookeeper_server.pid")
  tar -cvzf ${zk_bkp}/zk_${pattern}_cfg.tgz ${zk_cfg} -P
fi
chmod o-rwx ${zk_bkp}/zk_${pattern}*.tgz

find ${zk_bkp} -type f -mmin +$((${zk_rotation})) -name "*.tgz" -delete
