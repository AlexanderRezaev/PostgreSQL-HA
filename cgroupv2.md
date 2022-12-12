**Проблема стабильности работы distributed configuration store (DCS)**


**etcd**
https://etcd.io/docs/v3.5/op-guide/hardware/#disks
A slow disk will increase etcd request latency and potentially hurt cluster stability.

https://habr.com/ru/company/oleg-bunin/blog/489206/
Проблема 1. СУБД и DCS на одном кластере


**zookeeper**

https://github.com/AlexanderRezaev/PostgreSQL-HA/ioping_slow.jpg
https://github.com/AlexanderRezaev/PostgreSQL-HA/zookeeper_slow.jpg


**cgroup v2**

https://docs.kernel.org/admin-guide/cgroup-v2.html
cgroup is a mechanism to organize processes hierarchically and distribute system resources along the hierarchy in a controlled and configurable manner.


