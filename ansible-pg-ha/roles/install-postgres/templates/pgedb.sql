REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO PUBLIC;

CREATE TABLE public.log_kills
(
	 kill				timestamp with time zone
	,killer				name	null	-- session_user кто выполнил kill
	,typekill			varchar(10)		-- terminate or cancel
	,ok					boolean			-- 1 ok, 0 fail (return code from pg_terminate_backend or pg_cancel_backend)
	,datid				oid		null	-- OID базы данных, к которой подключён этот серверный процесс
	,datname			name	null	-- Имя базы данных, к которой подключён этот серверный процесс
	,pid				integer	null	-- Идентификатор процесса этого серверного процесса
	,usesysid			oid		null	-- OID пользователя, подключённого к этому серверному процессу
	,usename			name	null	-- Имя пользователя, подключённого к этому серверному процессу
	,application_name	text	null	-- Название приложения, подключённого к этому серверному процессу
	,client_addr		inet	null	-- IP-адрес клиента, подключённого к этому серверному процессу. Значение null в этом поле означает, что клиент подключён через сокет Unix на стороне сервера или что это внутренний процесс, например, автоочистка.
	,client_hostname	text	null	-- Имя компьютера для подключённого клиента, получаемое в результате обратного поиска в DNS по client_addr. Это поле будет отлично от null только в случае соединений по IP и только при включённом режиме log_hostname.
	,client_port		integer	null	-- Номер TCP-порта, который используется клиентом для соединения с этим серверным процессом, или -1, если используется сокет Unix
	,backend_start		timestamp with time zone	null	-- Время запуска процесса. Для процессов, обслуживающих клиентов, это время подключения клиента к серверу.
	,xact_start			timestamp with time zone	null	-- Время начала текущей транзакции в этом процессе или null при отсутствии активной транзакции. Если текущий запрос был первым в своей транзакции, то значение в этом столбце совпадает со значением столбца query_start.
	,query_start		timestamp with time zone	null	-- Время начала выполнения активного в данный момент запроса, или, если state не active, то время начала выполнения последнего запроса
	,state_change		timestamp with time zone	null	-- Время последнего изменения состояния (поля state)
	,wait_event_type	text	null	-- Тип события, которого ждёт обслуживающий процесс, если это имеет место; в противном случае — NULL.
	,wait_event			text	null	-- Имя ожидаемого события, если обслуживающий процесс находится в состоянии ожидания, а в противном случае — NULL. За подробностями обратитесь к Таблице 27.4.
	,state				text	null	-- Общее текущее состояние этого серверного процесса.
	,backend_xid		xid		null	-- Идентификатор верхнего уровня транзакции этого серверного процесса или любой другой.
	,backend_xmin		xid		null	-- текущая граница xmin для серверного процесса.
	,backend_type		text	null	-- Тип текущего серверного процесса. Возможные варианты: autovacuum launcher, autovacuum worker, logical replication launcher, logical replication worker, parallel worker, background writer, client backend, checkpointer, startup, walreceiver, walsender и walwriter. Кроме того, фоновые рабочие процессы, регистрируемые расширениями, могут иметь дополнительные типы.
	,query				text	null	-- Текст последнего запроса этого серверного процесса. Если state имеет значение active, то в этом поле отображается запрос, который выполняется в настоящий момент. Если процесс находится в любом другом состоянии, то в этом поле отображается последний выполненный запрос. По умолчанию текст запроса обрезается до 1024 символов; это число определяется параметром track_activity_query_size.
)
;

ALTER TABLE public.log_kills OWNER to postgres;
GRANT SELECT ON TABLE public.log_kills TO PUBLIC;


CREATE TABLE public.log_connections
(
    dt timestamp with time zone NOT NULL,
    connection_count integer NOT NULL,
    hostname text COLLATE pg_catalog."default" NOT NULL
)
;
ALTER TABLE public.log_connections OWNER to postgres;
GRANT SELECT ON TABLE public.log_connections TO PUBLIC;

CREATE EXTENSION IF NOT EXISTS plperl;
CREATE LANGUAGE plperlu;


CREATE OR REPLACE FUNCTION hostname()
RETURNS text 
AS $BODY$
    use warnings;
    use strict;
    my $output = `hostname`;
    return($output);
$BODY$ LANGUAGE plperlu;

GRANT EXECUTE ON FUNCTION public.hostname() TO postgres;
GRANT EXECUTE ON FUNCTION public.hostname() TO PUBLIC;

CREATE OR REPLACE FUNCTION public.get_pid_cpu_mem(int) returns table(PID INT,cpu_perc float,mem_perc float,mem_kb float,line text) 
as
$$
  my $ps = "ps aux";
  my $awk = "awk '{if (\$2==".$_[0]."){print \$2\":\"\$3\":\"\$4\":\"\$6\":\"\$0}}'";
  my $cmd = $ps."|".$awk;
  $output = `$cmd 2>&1`;
  @output = split(/[\n\r]+/,$output);
  foreach $out (@output)
  { 
    my @line = split(/:/,$out);
    return_next{'pid' => $line[0],'cpu_perc' => $line[1], 'mem_perc' => $line[2], 'mem_kb' => $line[3], 'line' => $line[4]};
    return undef;
  }
  return;
$$ language plperlu;
