CREATE EXTENSION IF NOT EXISTS "file_fdw";

CREATE SERVER IF NOT EXISTS pglog FOREIGN DATA WRAPPER file_fdw;


CREATE OR REPLACE FUNCTION public.get_pathlog(
) RETURNS text LANGUAGE sql IMMUTABLE AS $body$
select (select setting as pathname from pg_settings where name='data_directory') || '/' || (select setting as filename from pg_settings where name='log_directory')::text;
$body$;


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

ALTER FUNCTION public.hostname() OWNER TO postgres;

GRANT EXECUTE ON FUNCTION public.hostname() TO PUBLIC;



CREATE FUNCTION public._crfile(location text) RETURNS text AS $BODY$
    use warnings;
    use strict;
    my $location = $_[0];
    my $output = `$location`;
    return($output);
$BODY$ LANGUAGE plperlu;


DO $do$
DECLARE w record;
DECLARE h record;
DECLARE ta record;
declare tz text;
BEGIN
	SELECT setting::text INTO tz FROM pg_settings WHERE name in ( 'log_timezone' );

	CREATE TABLE public.pglog (
		log_time timestamp(3) with time zone NULL
		,user_name text NULL COLLATE pg_catalog."default"
		,database_name text NULL COLLATE pg_catalog."default"
		,process_id integer NULL
		,connection_from text NULL COLLATE pg_catalog."default"
		,session_id text NULL COLLATE pg_catalog."default"
		,session_line_num bigint NULL
		,command_tag text NULL COLLATE pg_catalog."default"
		,session_start_time timestamp with time zone NULL
		,virtual_transaction_id text NULL COLLATE pg_catalog."default"
		,transaction_id bigint NULL
		,error_severity text NULL COLLATE pg_catalog."default"
		,sql_state_code text NULL COLLATE pg_catalog."default"
		,message text NULL COLLATE pg_catalog."default"
		,detail text NULL COLLATE pg_catalog."default"
		,hint text NULL COLLATE pg_catalog."default"
		,internal_query text NULL COLLATE pg_catalog."default"
		,internal_query_pos integer NULL
		,context text NULL COLLATE pg_catalog."default"
		,query text NULL COLLATE pg_catalog."default"
		,query_pos integer NULL
		,location text NULL COLLATE pg_catalog."default"
		,application_name text NULL COLLATE pg_catalog."default"
{% if postgresql_version | int >= 13 %}
		,backend_type text NULL COLLATE pg_catalog."default"
{% endif %}
{% if postgresql_version | int >= 14 %}
		,leader_pid integer NULL
		,query_id bigint NULL
{% endif %}
	) PARTITION BY RANGE (log_time);

    FOR w IN SELECT to_char((date_trunc('week',current_date AT TIME ZONE tz)::date) + i,'Dy') as wkday FROM generate_series(0,6) i
    LOOP
		FOR h IN SELECT to_char(a.n,'FM09') as "hours" FROM generate_series(0, 23) as a(n)
		LOOP
			EXECUTE 'CREATE FOREIGN TABLE public."postgresql-' || w.wkday || '-' || h.hours || '" (
				log_time timestamp(3) with time zone NULL
				,user_name text NULL COLLATE pg_catalog."default"
				,database_name text NULL COLLATE pg_catalog."default"
				,process_id integer NULL
				,connection_from text NULL COLLATE pg_catalog."default"
				,session_id text NULL COLLATE pg_catalog."default"
				,session_line_num bigint NULL
				,command_tag text NULL COLLATE pg_catalog."default"
				,session_start_time timestamp with time zone NULL
				,virtual_transaction_id text NULL COLLATE pg_catalog."default"
				,transaction_id bigint NULL
				,error_severity text NULL COLLATE pg_catalog."default"
				,sql_state_code text NULL COLLATE pg_catalog."default"
				,message text NULL COLLATE pg_catalog."default"
				,detail text NULL COLLATE pg_catalog."default"
				,hint text NULL COLLATE pg_catalog."default"
				,internal_query text NULL COLLATE pg_catalog."default"
				,internal_query_pos integer NULL
				,context text NULL COLLATE pg_catalog."default"
				,query text NULL COLLATE pg_catalog."default"
				,query_pos integer NULL
				,location text NULL COLLATE pg_catalog."default"
				,application_name text NULL COLLATE pg_catalog."default"
{% if postgresql_version | int >= 13 %}
				,backend_type text NULL COLLATE pg_catalog."default"
{% endif %}
{% if postgresql_version | int >= 14 %}
				,leader_pid integer NULL
				,query_id bigint NULL
{% endif %}
			)
			SERVER pglog
			OPTIONS (filename ''' || public.get_pathlog() || '/postgresql-' || w.wkday || '-' || h.hours || '.csv'', format ''csv'', encoding ''UTF8'');';

		END LOOP;
	END LOOP;

	FOR ta IN SELECT dtfrom ,dtfrom+interval'1 hour' as dtto ,to_char(dtfrom AT TIME ZONE tz,'Dy') as wd,'pglog_' || to_char(dtfrom AT TIME ZONE tz,'dy') || '_' || to_char(dtfrom AT TIME ZONE tz,'HH24') as pn 
		,'ALTER TABLE public.pglog ATTACH PARTITION "postgresql-' || to_char(dtfrom AT TIME ZONE tz,'Dy') || '-' || to_char(dtfrom AT TIME ZONE tz,'HH24') || '" '
			'FOR VALUES FROM (''' || ( dtfrom::timestamptz ) || '''::timestamptz) TO (''' || ((dtfrom+interval'1 hour')::timestamptz) || '''::timestamptz);' as cmd
		,	'test -e "' || public.get_pathlog() || '/postgresql-' || to_char(dtfrom AT TIME ZONE tz,'Dy') || '-' || to_char(dtfrom AT TIME ZONE tz,'HH24') || '.csv"' 
			' || touch "' || public.get_pathlog() || '/postgresql-' || to_char(dtfrom AT TIME ZONE tz,'Dy') || '-' || to_char(dtfrom AT TIME ZONE tz,'HH24') || '.csv";' as cmdfile
		FROM generate_series( (date_trunc('hour',(now()::timestamptz AT TIME ZONE tz)-interval'7 days'+interval'1 hour')::timestamp AT TIME ZONE tz)::timestamptz
					 ,(date_trunc('hour',(now()::timestamptz AT TIME ZONE tz))::timestamp AT TIME ZONE tz)::timestamptz
					 ,'1 hours' ) a(dtfrom)
	LOOP
		EXECUTE ta.cmd;
		PERFORM public._crfile(ta.cmdfile);
		--RAISE WARNING '[%]', ta.cmd;
	END LOOP;

END $do$;

DROP FUNCTION public._crfile(text);

GRANT SELECT ON TABLE public.pglog TO PUBLIC;




DROP FUNCTION IF EXISTS public.log_state();

CREATE OR REPLACE FUNCTION public.log_state()
RETURNS table(parent_schema text ,parent_table text ,child_schema text ,child_table text ,partition_expression text ,filename text ,dtleft timestamptz ,dtright timestamptz ,filecheck bool ,datacheck bool, dtfirst timestamp with time zone, dtlast timestamp with time zone, size bigint) as
$$
/*
	SELECT count(*) FROM public.log_state();
	-- must be 168

	SET SESSION TIME ZONE 'Etc/UTC';
	SELECT to_char(size/1024./1024., '0D99')||'MB' as "sizeMB", size, * FROM public.log_state() ORDER BY dtleft DESC;

	SET SESSION TIME ZONE 'Europe/Moscow';
	SELECT to_char(size/1024./1024., '0D99')||'MB' as "sizeMB", size, * FROM public.log_state() WHERE datacheck=false ORDER BY dtleft DESC;

	SET SESSION TIME ZONE 'Etc/UTC';
	select * from public.log_state() where filecheck=true and datacheck is not null order by dtleft desc;

	SET SESSION TIME ZONE 'Europe/Moscow';
	select * from public.log_state() where filecheck=true and datacheck is not null order by dtleft desc;

	SET SESSION TIME ZONE 'Europe/Moscow';
	select * from public.log_state() where filecheck=true and datacheck is null order by dtleft desc; -- size=0

	SET SESSION TIME ZONE 'Europe/Moscow';
	select * from public.log_state() where filecheck=true and datacheck=false order by dtleft desc;

	select * from public.log_state() order by dtleft;
	select * from public.log_state() order by filecheck, datacheck, dtleft;
	select * from public.log_state() where filecheck=false;
	select * from public.log_state() where filecheck=true and (datacheck=false or datacheck is null);

	SET SESSION TIME ZONE 'Europe/Moscow';
	SELECT * FROM public.log_state() WHERE filecheck=true ORDER BY dtleft DESC;
	SELECT * FROM public.log_state() WHERE datacheck is not null ORDER BY dtleft DESC;
	SELECT * FROM public.pglog WHERE not (database_name='pglogger' AND command_tag='VACUUM') ORDER BY log_time desc LIMIT 40;
	SELECT * FROM public.pglog WHERE error_severity not in ('LOG', 'WARNING') ORDER BY log_time desc LIMIT 40;
	SELECT * FROM public.pglog WHERE log_time >= date(now()) ORDER BY log_time desc LIMIT 40;

	если есть проблемы с порядком записей в pglog (позднее время раньше), особенно при ре-старте linux, то нужно смотреть 
	cat /var/log/messages | grep "ovfl timer"
*/
declare
	r record;
	sqlquery1 text;
	sqlquery2 text;
	sqlquery3 text;
BEGIN
	FOR r IN SELECT
			  nmsp_parent.nspname::text AS parent_schema
			, parent.relname::text AS parent_table
			, nmsp_child.nspname::text AS child_schema
			, child.relname::text AS child_table
			, pg_get_expr(child.relpartbound, child.oid, true) as partition_expression
			, public.get_pathlog() || '/' || child.relname || '.csv' as filename
			, regexp_replace( regexp_replace( pg_get_expr(child.relpartbound, child.oid, true), '^.*FROM [(]''', '' ), '''[)].*', '' ) as dtleft
			, regexp_replace( regexp_replace( pg_get_expr(child.relpartbound, child.oid, true), '^.*TO [(]''', '' ), '''[)]', '' ) as dtright
			, ((select setting from pg_settings where name = 'log_directory') || '/' || child.relname || '.csv') as relpath
		FROM pg_inherits
		JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
		JOIN pg_class child ON pg_inherits.inhrelid = child.oid
		JOIN pg_namespace nmsp_parent ON nmsp_parent.oid = parent.relnamespace
		JOIN pg_namespace nmsp_child ON nmsp_child.oid = child.relnamespace
		WHERE parent.relname = 'pglog'
	LOOP
		parent_schema := r.parent_schema;
		parent_table := r.parent_table;
		child_schema := r.child_schema;
		child_table := r.child_table;
		partition_expression := r.partition_expression;
		filename := r.filename;
		dtleft := r.dtleft;
		dtright := r.dtright;
		filecheck := true;

		BEGIN
			size := (SELECT ts.size FROM pg_stat_file(r.relpath) as ts);
		EXCEPTION
			WHEN OTHERS THEN
				size := null::bigint;
				filecheck := false;
		END;

		sqlquery1 := 'SELECT CASE WHEN log_time::timestamptz >= ''' || (r.dtleft::timestamptz) || ''' AND log_time::timestamptz < ''' || (r.dtright::timestamptz) || ''' THEN true ELSE false END as v FROM ' || quote_ident(rtrim(ltrim(r.child_schema,'"'),'"')) || '.' || quote_ident(rtrim(ltrim(r.child_table,'"'),'"')) || ' ORDER BY log_time LIMIT 1';
		sqlquery2 := 'SELECT log_time::timestamptz as v FROM ' || quote_ident(rtrim(ltrim(r.child_schema,'"'),'"')) || '.' || quote_ident(rtrim(ltrim(r.child_table,'"'),'"')) || ' ORDER BY log_time LIMIT 1';
		sqlquery3 := 'SELECT log_time::timestamptz as v FROM ' || quote_ident(rtrim(ltrim(r.child_schema,'"'),'"')) || '.' || quote_ident(rtrim(ltrim(r.child_table,'"'),'"')) || ' ORDER BY log_time DESC LIMIT 1';

		IF filecheck = true THEN
			BEGIN
				--RAISE WARNING '1[%]', sqlquery;
				datacheck := false;
				EXECUTE sqlquery1 INTO datacheck;
				--RAISE WARNING 'datacheck[%]', datacheck;
			EXCEPTION
				WHEN OTHERS THEN
					RAISE WARNING 'Unknown Log Format in [%]', quote_ident(rtrim(ltrim(r.child_table,'"'),'"')) USING ERRCODE = '01L00';
					--RAISE WARNING '[%]', sqlquery;
			END;

			--RAISE WARNING '2[%]', sqlquery;
			EXECUTE sqlquery2 INTO dtfirst;
			EXECUTE sqlquery3 INTO dtlast;
			IF dtlast > r.dtright::timestamptz THEN datacheck := false; END IF;
			--RAISE WARNING 'dtfirst[%]', dtfirst;
			--PERFORM public.log_switch( child_schema, child_table, date_trunc('hour',dtfirst::timestamptz) );
		ELSE
			dtfirst := null;
			dtlast := null;
		END IF;

        RETURN NEXT;
	END LOOP;
	RETURN;
end
$$ language plpgsql;



DROP FUNCTION IF EXISTS public.log_switch();

CREATE OR REPLACE FUNCTION public.log_switch()
RETURNS bool
AS
$BODY$
/*
	Раз в час нужно менять FOR VALUES FROM, чтобы план выполнения запроса по pglog строился правильно

	select * from public.log_state() where filecheck=true and (datacheck=false or datacheck is null);
	select public.log_switch();
	
	SELECT * FROM public.pglog WHERE log_time > '2020-03-05' ORDER BY log_time desc LIMIT 40;

       	SET SESSION TIME ZONE 'Europe/Moscow';
       	SELECT * FROM public.pglog ORDER BY log_time desc LIMIT 40;
*/
declare partname text;
declare tz text;
BEGIN
	SELECT setting::text INTO tz FROM pg_settings WHERE name in ( 'log_timezone' );
	partname := 'postgresql-' || to_char(now() AT TIME ZONE tz,'Dy') || '-' || to_char(now() AT TIME ZONE tz,'HH24');
	--RAISE WARNING 'partname[%]', partname;
	RAISE WARNING 'Every hour counts! In order every file is not empty.' USING ERRCODE = '01L01';
	PERFORM public.log_switch( 'public', partname, date_trunc( 'hour',now() AT TIME ZONE tz) );
	RETURN true;
END;
$BODY$ LANGUAGE plpgsql SECURITY DEFINER;


DROP FUNCTION IF EXISTS public.log_switch(sch text, tbl text, dtf timestamptz);

CREATE OR REPLACE FUNCTION public.log_switch(sch text, tbl text, dtf timestamptz)
RETURNS bool
AS
$BODY$
/*
	Раз в час нужно менять FOR VALUES FROM, чтобы план выполнения запроса по pglog строился правильно
	Что будет, если сервер был выключен более часа ?????

	select * from public.log_state() where filecheck=true and (datacheck=false or datacheck is null) order by child_table;
	select * from public.log_state() where filecheck=false;

	select public.log_switch('public','postgresql-Thu-12');
	ALTER TABLE pglog DETACH PARTITION "postgresql-Thu-12";
	ALTER TABLE public.pglog ATTACH PARTITION "public"."postgresql-Thu-12" FOR VALUES FROM ('2020-03-05 12:00:00+03') TO ('2020-03-05 13:00:00+03');

	select public.log_switch('public','postgresql-Wed-09',date_trunc('hour','2020-04-08 09:00'::timestamptz));

       	SET SESSION TIME ZONE 'Europe/Moscow';
       	SELECT * FROM public.pglog ORDER BY log_time desc LIMIT 40;
*/
declare	sqlquery text;
declare	sqlquery0 text;
declare	sqlqueryA text;
declare	sqlqueryB text;
declare dt timestamptz;
declare rc bool;
declare isStandby bool;
DECLARE
    v_state   TEXT;
    v_msg     TEXT;
    v_detail  TEXT;
    v_hint    TEXT;
    v_context TEXT;
BEGIN
	sqlquery := 'SELECT log_time FROM ' || quote_ident(rtrim(ltrim(sch,'"'),'"')) || '.' || quote_ident(rtrim(ltrim(tbl,'"'),'"')) || ' ORDER BY log_time LIMIT 1';
	BEGIN
		EXECUTE sqlquery INTO dt;
	EXCEPTION
		WHEN OTHERS THEN
		--RAISE WARNING 'log_time[%]', sqlquery;
		RETURN false;
	END;

	isStandby := (SELECT pg_is_in_recovery());
	IF isStandby = false THEN

		sqlqueryA := 'ALTER TABLE ' || quote_ident(rtrim(ltrim(sch,'"'),'"')) || '.pglog DETACH PARTITION ' || quote_ident(rtrim(ltrim(sch,'"'),'"')) || '.' || quote_ident(rtrim(ltrim(tbl,'"'),'"')) || ';';
		--RAISE WARNING 'DETACH[%]', sqlqueryA;
		BEGIN
			EXECUTE sqlqueryA;
		EXCEPTION
			WHEN OTHERS THEN

				get stacked diagnostics
				v_state   = returned_sqlstate,
				v_msg     = message_text,
				v_detail  = pg_exception_detail,
				v_hint    = pg_exception_hint,
				v_context = pg_exception_context;

				RAISE WARNING 'DETACH[%]', sqlqueryA USING ERRCODE = '01L02';

				RAISE WARNING E'Got exception:
					state  : %
					message: %
					detail : %
					hint   : %
					context: %', v_state, v_msg, v_detail, v_hint, v_context USING ERRCODE = '01L04';

				RETURN false;
		END;

		sqlqueryB := 'ALTER TABLE ' || quote_ident(rtrim(ltrim(sch,'"'),'"')) || '.pglog ATTACH PARTITION ' || quote_ident(rtrim(ltrim(sch,'"'),'"')) || '.' || quote_ident(rtrim(ltrim(tbl,'"'),'"')) || ' FOR VALUES FROM (''' || date_trunc('hour',COALESCE(dt,dtf))::timestamptz || ''') TO (''' || date_trunc('hour',COALESCE(dt,dtf)::timestamptz+interval'1 hour') || ''');';
		--RAISE WARNING 'ATTACH[%]', sqlqueryB;
		BEGIN
			EXECUTE sqlqueryB;
		EXCEPTION
			WHEN OTHERS THEN

				get stacked diagnostics
				v_state   = returned_sqlstate,
				v_msg     = message_text,
				v_detail  = pg_exception_detail,
				v_hint    = pg_exception_hint,
				v_context = pg_exception_context;

				RAISE WARNING 'ATTACH[%]', sqlqueryB USING ERRCODE = '01L03';
				-- ERROR:  partition "postgresql-Wed-15" would overlap partition "postgresql-Wed-16"

				RAISE WARNING E'Got exception:
					state  : %
					message: %
					detail : %
					hint   : %
					context: %', v_state, v_msg, v_detail, v_hint, v_context USING ERRCODE = '01L05';

				RETURN false;
		END;

	END IF;

	RETURN true;
END;
$BODY$ LANGUAGE plpgsql SECURITY DEFINER;
