**Проблема стабильности работы distributed configuration store (DCS)**

Проблема может заключаться в:<BR>
- работе Linux<BR>
- работе контроллера IO<BR>
- работе диска<BR>

Поскольку, в общем случае, мало что можно сделать с контроллером и диском, то обратим внимание на работу Linux.<BR>


<BR>**etcd**<BR>

https://etcd.io/docs/v3.5/op-guide/hardware/#disks<BR>
A slow disk will increase etcd request latency and potentially hurt cluster stability.<BR>

https://etcd.io/docs/v3.5/tuning/#disk<BR>
best effort, highest priority<BR>
$ sudo ionice -c2 -n0 -p $(pgrep -a etcd | awk '{ print $1 }')<BR>

https://habr.com/ru/company/oleg-bunin/blog/489206/<BR>
Проблема 1. СУБД и DCS на одном кластере<BR>


<BR>**zookeeper**<BR>

Анализ лога zookeeper:<BR>
![image](https://github.com/AlexanderRezaev/PostgreSQL-HA/blob/master/zookeeper_slow.jpg)<BR>
Вывод утилиты ioping (замеряет latency диска каждую секунду) работавшей параллельно:<BR>
![image](https://github.com/AlexanderRezaev/PostgreSQL-HA/blob/master/ioping_slow.jpg)<BR>


<BR>В cgroup v1 контроллер io не регулирует буферизованный ввод-вывод.<BR>

<BR>**cgroup v2**<BR>

https://docs.kernel.org/admin-guide/cgroup-v2.html<BR>
cgroup is a mechanism to organize processes hierarchically and distribute system resources along the hierarchy in a controlled and configurable manner.<BR>

По умолчанию cgroup v2 работает в ALT Linux 10, Ubuntu 22.04 LTS<BR>

ALT Linux 10<BR>
<pre><code># ls -la /sys/fs/cgroup/critical.slice/ | grep 'io\.'
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.bfq.weight
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.latency
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.low
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.max
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.pressure
-r--r--r--  1 root     root     0 Dec 11 09:33 io.stat
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.weight
</code></pre>

Ubuntu 22.04 LTS
<pre><code># ls -la /sys/fs/cgroup/critical.slice/ | grep 'io\.'
-rw-r--r--  1 root     root     0 Dec 12 11:27 io.max
-rw-r--r--  1 root     root     0 Dec 12 11:27 io.pressure
-rw-r--r--  1 root     root     0 Dec 12 11:27 io.prio.class
-r--r--r--  1 root     root     0 Dec 12 11:26 io.stat
-rw-r--r--  1 root     root     0 Dec 12 11:26 io.weight
</code></pre>

Настройки осуществляются по<BR>
https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html<BR>

<pre><code>sed -i '/^\[Service\]/a Delegate=cpu memory io' /lib/systemd/system/etcd.service
sed -i '/^\[Service\]/a Slice=critical.slice' /lib/systemd/system/etcd.service

sed -i '/^\[Service\]/a Delegate=cpu memory io' /lib/systemd/system/patroni.service
sed -i '/^\[Service\]/a Slice=critical.slice' /lib/systemd/system/patroni.service

sed -i '/^\[Service\]/a Delegate=cpu memory io' /lib/systemd/system/pgagent.service
sed -i '/^\[Service\]/a Slice=critical.slice' /lib/systemd/system/pgagent.service

sed -i '/^\[Service\]/a Delegate=cpu memory io' /lib/systemd/system/pgbouncer.service
sed -i '/^\[Service\]/a Slice=critical.slice' /lib/systemd/system/pgbouncer.service

sed -i '/^\[Service\]/a Delegate=cpu memory io' /lib/systemd/system/pgpool.service
sed -i '/^\[Service\]/a Slice=critical.slice' /lib/systemd/system/pgpool.service

sed -i '/^\[Service\]/a Delegate=cpu memory io' /lib/systemd/system/postgresql.service
sed -i '/^\[Service\]/a Slice=critical.slice' /lib/systemd/system/postgresql.service

systemctl daemon-reload
systemctl restart etcd.service 
systemctl restart patroni.service
patronictl switchover

systemd-cgls --no-pager | grep -v color | grep 'slice\|service'

-.slice
├─critical.slice 
│ ├─pgpool.service …
│ ├─pgagent.service …
│ ├─etcd.service …
│ ├─pgbouncer.service …
│ └─patroni.service …
├─user.slice 
│ └─user-0.slice 
│   └─user@0.service …
└─system.slice 
  ├─systemd-udevd.service 
  ├─chronyd.service 
  ├─systemd-journald.service 
  ├─sshd.service 
  ├─crond.service 
  ├─nslcd.service 
  ├─systemd-userdbd.service 
  ├─rpcbind.service 
  ├─nscd.service 
  ├─postfix.service 
  ├─alteratord.service 
  ├─dbus.service 
  ├─system-getty.slice 
  │ └─getty@tty1.service 
  └─systemd-logind.service 

df -hT | grep -v 'squashfs\|tmpfs\|overlay'

Filesystem                             Type      Size  Used Avail Use% Mounted on
/dev/sda1                              ext4       32G  2.9G   27G  10% /
/dev/mapper/dcs_vg-dcs                 ext4      3.9G  123M  3.6G   4% /dcs
/dev/mapper/postgresql_wal_vg-pg_wal   ext4      5.9G  305M  5.3G   6% /pg_wal
/dev/mapper/postgresql_data_vg-pg_data xfs       8.0G  129M  7.9G   2% /pg_data

mkdir -p /etc/systemd/system/etcd.service.d
echo '[Service]' > /etc/systemd/system/etcd.service.d/cpu.conf
echo 'CPUQuota=8%' >> /etc/systemd/system/etcd.service.d/cpu.conf
echo 'MemoryLimit=80M' >> /etc/systemd/system/etcd.service.d/cpu.conf
echo 'IODeviceLatencyTargetSec=/dev/mapper/dcs_vg-dcs 50ms' >> /etc/systemd/system/etcd.service.d/cpu.conf

systemctl daemon-reload
systemctl restart etcd.service 

cgget -r cpu.max /critical.slice/etcd.service
/critical.slice/etcd.service:
cpu.max: 8000 100000

cgget -r memory.max /critical.slice/etcd.service
/critical.slice/etcd.service:
memory.max: 83886080

cgget -r io.latency /critical.slice/etcd.service
/critical.slice/etcd.service:
io.latency: 8:48 target=50000

</code></pre>


<BR>**Замечание**<BR>

Установка и использование ioping<BR>

<pre><code>apt-get install moreutils ioping
# dnf config-manager --set-enabled powertools
# dnf -y install moreutils ioping

timeout 60 ioping /dev/sda1 | ts '[%FT%T%z]' | tee /var/log/ioping.log
</code></pre>

- запускает на 60 секунд ioping с логированием в файл<BR>
