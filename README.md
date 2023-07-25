**Кластер PostgreSQL высокой доступности без потери транзакций и с защитой от split-brain.**

---

Замечание

> Понятие кластеризации несколько шире (см <https://gitlab.com/gitlab-com/gl-infra/infrastructure/-/issues/7282>)
>
> Можно ли быть недоступным в течение определенных периодов времени или лучше быть (почти) всегда доступным, терпя при этом определенную потерю данных?
>
> PostgreSQL поддерживает три возможных компромисса между согласованностью (C) и доступностью (A):
>
> **Асинхронный.** Предпочитает A, а не C. Это наиболее часто используемый режим. Наиболее нетребовательный к ресурсам. Предполагает наличие минимум 2-х узлов.
>
> **Синхронный.** Предпочитает C, а не A. Доступность ниже, чем на одном узле. Любой отказавший синхронный узел вызывает недоступность кластера до тех пор, пока он не вернется в исходное состояние или не будет заменен. Из-за этого это редко применяется. Предполагает наличие минимум 2-х узлов.
>
> **Полусинхронный.** Некоторые узлы синхронны, остальные асинхронны. Предполагает наличие минимум 3-х узлов.
>
> Выбор кластеризации определяется в первую очередь бизнесом.

Далее рассматривается построение кластера PostgreSQL высокой доступности без потери закоммиченных данных (предпочтение согласованности) и с защитой от split-brain.

<https://en.wikipedia.org/wiki/Split-brain_(computing)>

Современные коммерческие кластеры высокой доступности общего назначения обычно используют комбинацию пульса (heartbeat) между узлами кластера и хранилища-свидетеля кворума (quorum). Проблема с двухузловыми кластерами заключается в том, что добавление устройства-свидетеля увеличивает стоимость и сложность (даже если оно реализовано в облаке), но без него в случае сбоя heartbeat члены кластера не могут определить, какое из них должно быть активным. В таких кластерах (без кворума) в случае сбоя члена, даже если члены имеют первичный и вторичный статус, существует по крайней мере 50% вероятность того, что кластер высокой доступности с 2 узлами полностью выйдет из строя, пока не будет обеспечено вмешательство человека, чтобы предотвратить активацию нескольких членов независимо друг от друга и, следовательно, несоответствие или повреждение данных.

**Введение**

Разница между отказоустойчивостью и высокой доступностью заключается в том, что отказоустойчивая среда не имеет прерывания обслуживания, но имеет значительно более высокую стоимость, тогда как **среда высокой доступности имеет минимальное прерывание обслуживания**.

Термин "**минимальное прерывание обслуживания**" понятие растяжимое, поэтому рассматривались все варианты реализации высокой доступности, начиная с простого бэкапирования.

\1. Непрерывное архивирование и восстановление на момент времени (Point-in-Time Recovery, PITR) <https://postgrespro.ru/docs/postgresql/10/continuous-archiving>

\2. В документации PostgreSQL есть описание и краткое сравнение различных решений высокой доступности <https://postgrespro.ru/docs/postgresql/10/different-replication-solutions>

- Отказоустойчивость на разделяемых дисках
- Репликация на уровне файловой системы (блочного устройства)
- Трансляция журнала предзаписи
- …
- Асинхронная репликация
- Синхронная репликация

В результате поисков в Интернет были отброшены практически все описанные варианты (либо из-за потери транзакций, либо из-за отсутствия надёжной и простой защиты от split-brain, либо из-за того и другого одновременно).

Единственный вариант, который обладает и защитой от потери закоммиченных транзакций, и защитой от split-brain, это **синхронная репликация в режиме кворума**.

<https://postgrespro.ru/docs/postgresql/10/runtime-config-replication#GUC-SYNCHRONOUS-STANDBY-NAMES>

**synchronous\_standby\_names**: 'ANY 1 ("pg-1","pg-2","pg-3")'

\- синхронная потоковая репликацию на основе кворума, когда транзакции фиксируются только после того, как их записи в WAL реплицируются как минимум на 1 из ведомых серверов (кворум 2 из 3-х).

В данной конфигурации невозможен split-brain. Даже если два сервера объявят себя master, то работать сможет только один из них, т.к. для фиксации транзакции нужен ещё и slave, а slave будет работать только с одним master (определяется timeline <https://habr.com/ru/company/pgdayrussia/blog/327750/>).

Данная конфигурация позволяет перезагружать/останавливать/обслуживать любой узел с postgres не прерывая работы кластера.

Замечание

>Также является важным параметр **synchronous\_commit**
>
><https://www.enterprisedb.com/blog/why-use-synchronous-replication-in-postgresql-configure-streaming-replication-wal>
>
>Когда произошел сбой, транзакции, которые находились на пути от walsender к процессу walreceiver, были потеряны.
>
>Минимальные требования: **synchronous\_commit = on**
>
><https://postgrespro.ru/docs/postgresql/10/runtime-config-wal#GUC-SYNCHRONOUS-COMMIT>
>
><https://www.2ndquadrant.com/en/blog/evolution-fault-tolerance-postgresql-synchronous-commit/>
>
>**synchronous\_commit = off** - коммиты отправляются в приложение, после того как транзакция обрабатывается внутренним процессом, но до того, как транзакция сброшена в WAL. Это означает, что даже один сервер гипотетически может потерять данные. Сама репликация игнорируется.
>
>**synchronous\_commit = local** - коммиты отправляются в приложение, как только данные сбрасываются в WAL на первичный узле. Сама репликация игнорируется. Думайте об этом, как смеси между выключенным и включенным, где он обеспечивает локальные WAL, игнорируя согласованность реплик.
>
>**synchronous\_commit = remote\_write** - write коммиты отправляются в приложение после того, как операционная система резервных серверов, определенных в synchronous\_standby\_names, отправит подтверждение транзакций, отправленных основным Walsender. Это продвигает нас на шаг вперед.
>
>**synchronous\_commit = on** - коммиты отправляются в приложение, как только данные сбрасываются в WAL. Это применимо как к основному серверу в конфигурации с одним сервером, так и к резервным серверам при потоковой репликации. На самом деле это на один шаг дальше, чем remote\_write, поскольку он обеспечивает фиксацию только после того, как он попал в резервный WAL.
>
>**synchronous\_commit = remote\_apply** - подтверждение отправляет в приложение только после того, как резервные серверы, включенные в synchronous\_standby\_names, подтверждают, что транзакции были применены за пределами WAL к самой базе данных.
>
>**о производительности репликации**
>
>` `<https://www.cybertec-postgresql.com/en/the-synchronous_commit-parameter/>
>
>"async on" - 4256 TPS (здесь 1 транзакция означает 3 обновления, 1 вставку, 1 выбор)
>
>"async off" - 6211 TPS (+45% по сравнению с "async on")
>
>"sync on" - 3329 TPS (-22% по сравнению со значением по умолчанию "async on")
>
>"sync remote\_write" - 3720 TPS (+12% по сравнению с "sync on")
>
>"sync remote\_apply" - 3055 TPS (-8% по сравнению с "sync on")

Для построения кластера также требуется определить единую точку входа. Проще всего это обеспечить через Cluster IP.

**Вышеперечисленного достаточно, чтобы вручную построить кластер.**

---

Для автоматической работы кластера требуется выполнение дополнительных действий: определение, в случае падения master, кто станет следующим master, а так же выполнение операций по перенастройке PostgreSQL на узлах, промоут роли в кластере, синхронизация реплики и запуск PostgreSQL. Всё это выливается в достаточно внушительный список операций.

Для выполнения всего перечисленного предпочтительнее использовать Patroni (<https://github.com/zalando/patroni>) - оркестратор работы высокодоступного кластера PostgreSQL (PostgreSQL High-Available Orchestrator)

Учитывая наличие в Patroni callback скриптов, достаточно просто реализовать Cluster IP <https://patroni.readthedocs.io/en/latest/yaml_configuration.html?highlight=callbacks>

Для работы Cluster IP в сегментированных корпоративных сетях используется ARP announcements <https://en.wikipedia.org/wiki/Address_Resolution_Protocol#ARP_announcements> (используется стандартно в кластерах pgpool).

---

В результате выполнения ansible скриптов <BR>
(https://github.com/AlexanderRezaev/PostgreSQL-HA/tree/master/ansible-pg-ha)<BR>
получаем PostgreSQL кластер:

<pre><code>
root@c8-h1:~# patronictl --help
Usage: patronictl [OPTIONS] COMMAND [ARGS]...

Options:
  -c, --config-file TEXT  Configuration file
  -d, --dcs TEXT          Use this DCS
  -k, --insecure          Allow connections to SSL sites without certs
  --help                  Show this message and exit.

Commands:
  configure    Create configuration file
  dsn          Generate a dsn for the provided member, defaults to a dsn...
  edit-config  Edit cluster configuration
  failover     Failover to a replica
  flush        Discard scheduled events
  history      Show the history of failovers/switchovers
  list         List the Patroni members for a given Patroni
  pause        Disable auto failover
  query        Query a Patroni PostgreSQL member
  reinit       Reinitialize cluster member
  reload       Reload cluster member configuration
  remove       Remove cluster from DCS
  restart      Restart cluster member
  resume       Resume auto failover
  scaffold     Create a structure for the cluster in DCS
  show-config  Show cluster configuration
  switchover   Switchover to a replica
  topology     Prints ASCII topology for given cluster
  version      Output version of patronictl command or a running Patroni...


root@c8-h1:~# patronictl list
+--------+------------+---------+---------+----+-----------+
| Member | Host       | Role    | State   | TL | Lag in MB |
+ Cluster: c8-cls (7087222557044476438) --+----+-----------+
| c8-h1  | c8-h1:5434 | Replica | running |  5 |         0 |
| c8-h2  | c8-h2:5434 | Leader  | running |  5 |           |
| c8-h3  | c8-h3:5434 | Replica | running |  5 |         0 |
+--------+------------+---------+---------+----+-----------+

root@c8-h1:~# PGPASSWORD=secret psql -h c8-cls -p 5434 -U foo -d postgres -X -c "SELECT application_name,client_addr,usename,state,sync_state,sync_priority,write_lag,flush_lag,replay_lag FROM pg_stat_replication;"
 application_name |  client_addr   |  usename   |   state   | sync_state | sync_priority |    write_lag    |    flush_lag    |   replay_lag    
------------------+----------------+------------+-----------+------------+---------------+-----------------+-----------------+-----------------
 c8-h1            | 172.27.172.144 | clsreplica | streaming | quorum     |             1 | 00:00:00.000511 | 00:00:00.000763 | 00:00:00.000918
 c8-h3            | 172.27.172.146 | clsreplica | streaming | quorum     |             1 | 00:00:00.000488 | 00:00:00.000918 | 00:00:00.001007
(2 rows)


root@c8-h1:~# patronictl failover
Candidate ['c8-h1', 'c8-h3'] []: c8-h3
Current cluster topology
+--------+------------+---------+---------+----+-----------+
| Member | Host       | Role    | State   | TL | Lag in MB |
+ Cluster: c8-cls (7087222557044476438) --+----+-----------+
| c8-h1  | c8-h1:5434 | Replica | running |  5 |         0 |
| c8-h2  | c8-h2:5434 | Leader  | running |  5 |           |
| c8-h3  | c8-h3:5434 | Replica | running |  5 |         0 |
+--------+------------+---------+---------+----+-----------+
Are you sure you want to failover cluster c8-cls, demoting current master c8-h2? [y/N]: y
2022-04-26 11:04:47.42876 Successfully failed over to "c8-h3"
+--------+------------+---------+----------+----+-----------+
| Member | Host       | Role    | State    | TL | Lag in MB |
+ Cluster: c8-cls (7087222557044476438) ---+----+-----------+
| c8-h1  | c8-h1:5434 | Replica | running  |  5 |         0 |
| c8-h2  | c8-h2:5434 | Replica | stopping |    |   unknown |
| c8-h3  | c8-h3:5434 | Leader  | running  |  5 |           |
+--------+------------+---------+----------+----+-----------+

root@c8-h1:~# # запускаем через минуту
root@c8-h1:~# patronictl list
+--------+------------+---------+---------+----+-----------+
| Member | Host       | Role    | State   | TL | Lag in MB |
+ Cluster: c8-cls (7087222557044476438) --+----+-----------+
| c8-h1  | c8-h1:5434 | Replica | running |  6 |         0 |
| c8-h2  | c8-h2:5434 | Replica | running |  6 |         0 |
| c8-h3  | c8-h3:5434 | Leader  | running |  6 |           |
+--------+------------+---------+---------+----+-----------+

root@c8-h1:~# PGPASSWORD=secret psql -h c8-cls -p 5434 -U foo -d postgres -X -c "SELECT application_name,client_addr,usename,state,sync_state,sync_priority,write_lag,flush_lag,replay_lag FROM pg_stat_replication;"
 application_name |  client_addr   |  usename   |   state   | sync_state | sync_priority |    write_lag    |    flush_lag    |   replay_lag    
------------------+----------------+------------+-----------+------------+---------------+-----------------+-----------------+-----------------
 c8-h2            | 172.27.172.145 | clsreplica | streaming | quorum     |             1 | 00:00:00.000587 | 00:00:00.00243  | 00:00:00.002434
 c8-h1            | 172.27.172.144 | clsreplica | streaming | quorum     |             1 | 00:00:00.00243  | 00:00:00.002436 | 00:00:00.002436
(2 rows)

# Прямое подключение к кластеру PG
root@c8-h1:~# PGPASSWORD=secret psql -xtA -h c8-cls -p 5434 -U foo -d pgedb -c 'select hostname();' # postgres
hostname|c8-h3.lab.local

# Подключение через pgbouncer
root@c8-h1:~# PGPASSWORD=secret psql -xtA -h c8-cls -p 6432 -U foo -d pgedb -c 'select hostname();' | sed -n '1p' # pgbouncer
hostname|c8-h3.lab.local

# Подключение через pgpool.
# Настроена балансировка нагрузки read-only. Функция hostname() помечена как read-only.
root@c8-h1:~# PGPASSWORD=secret psql -xtA -h c8-cls -p 9999 -U foo -d pgedb -c 'select hostname();' | sed -n '1p' # pgpool
hostname|c8-h3.lab.local

root@c8-h1:~# PGPASSWORD=secret psql -xtA -h c8-cls -p 9999 -U foo -d pgedb -c 'select hostname();' | sed -n '1p' # pgpool
hostname|c8-h2.lab.local

root@c8-h1:~# PGPASSWORD=secret psql -xtA -h c8-cls -p 9999 -U foo -d pgedb -c 'select hostname();' | sed -n '1p' # pgpool
hostname|c8-h2.lab.local

root@c8-h1:~# PGPASSWORD=secret psql -xtA -h c8-cls -p 9999 -U foo -d pgedb -c 'select hostname();' | sed -n '1p' # pgpool
hostname|c8-h1.lab.local


# Проверка что ipsec работает. ESP - Encapsulating Security Payload.
root@c8-h1:~# ipsec whack --trafficstatus
006 #3: "conn_172.27.172.144_172.27.172.145", type=ESP, add_time=1650959754, inBytes=236435391, outBytes=3667199, id='@c8-h2.lab.local'
006 #4: "conn_172.27.172.144_172.27.172.146", type=ESP, add_time=1650959756, inBytes=944431, outBytes=586282, id='@c8-h3.lab.local'
</code></pre>

**Кластер под высокой нарузкой**

Высокая нагрузка в кластере может сказаться на стабильности работы distributed configuration store (DCS) используемой в patroni.
Обычно советуют вынести DCS на отдельные сервера. Рассмотрению альтернативы в виде cgroup v2 посвящено:
https://github.com/AlexanderRezaev/PostgreSQL-HA/blob/master/cgroupv2.md
