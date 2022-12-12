**Проблема стабильности работы distributed configuration store (DCS)**


**etcd**<BR>

https://etcd.io/docs/v3.5/op-guide/hardware/#disks<BR>
A slow disk will increase etcd request latency and potentially hurt cluster stability.<BR>

https://habr.com/ru/company/oleg-bunin/blog/489206/<BR>
Проблема 1. СУБД и DCS на одном кластере<BR>


**zookeeper**<BR>

https://github.com/AlexanderRezaev/PostgreSQL-HA/blob/master/zookeeper_slow.jpg<BR>
https://github.com/AlexanderRezaev/PostgreSQL-HA/blob/master/ioping_slow.jpg<BR>


**cgroup v2**<BR>

https://docs.kernel.org/admin-guide/cgroup-v2.html<BR>
cgroup is a mechanism to organize processes hierarchically and distribute system resources along the hierarchy in a controlled and configurable manner.<BR>


