**Проблема стабильности работы distributed configuration store (DCS)**


**etcd**<BR>

https://etcd.io/docs/v3.5/op-guide/hardware/#disks<BR>
A slow disk will increase etcd request latency and potentially hurt cluster stability.<BR>

https://habr.com/ru/company/oleg-bunin/blog/489206/<BR>
Проблема 1. СУБД и DCS на одном кластере<BR>


**zookeeper**<BR>

Анализ лога zookeeper:<BR>
https://github.com/AlexanderRezaev/PostgreSQL-HA/blob/master/zookeeper_slow.jpg<BR>
Вывод утилиты ioping работавшей параллельно:<BR>
https://github.com/AlexanderRezaev/PostgreSQL-HA/blob/master/ioping_slow.jpg<BR>

В cgroup v1 контроллер io не регулирует буферизованный ввод-вывод.

**cgroup v2**<BR>

https://docs.kernel.org/admin-guide/cgroup-v2.html<BR>
cgroup is a mechanism to organize processes hierarchically and distribute system resources along the hierarchy in a controlled and configurable manner.<BR>

По умолчанию cgroup v2 работает в ALT Linux 10, Ubuntu 22.04 LTS<BR>

ALT Linux 10<BR>
<pre><code>
# ls -la /sys/fs/cgroup/critical.slice/ | grep 'io\.'
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.bfq.weight
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.latency
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.low
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.max
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.pressure
-r--r--r--  1 root     root     0 Dec 11 09:33 io.stat
-rw-r--r--  1 root     root     0 Dec 11 09:33 io.weight
</code></pre>

Ubuntu 22.04 LTS
<pre><code>
# ls -la /sys/fs/cgroup/critical.slice/ | grep 'io\.'
-rw-r--r--  1 root     root     0 Dec 12 11:27 io.max
-rw-r--r--  1 root     root     0 Dec 12 11:27 io.pressure
-rw-r--r--  1 root     root     0 Dec 12 11:27 io.prio.class
-r--r--r--  1 root     root     0 Dec 12 11:26 io.stat
-rw-r--r--  1 root     root     0 Dec 12 11:26 io.weight
</code></pre>

Настройки осуществляются по<BR>
https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html<BR>

<pre><code>
sed -i '/^\[Service\]/a Delegate=cpu memory io' /lib/systemd/system/etcd.service
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
