cat <<EOF | psql -p {{ postgresql_port }} -d postgres
COPY (SELECT usename, passwd FROM pg_shadow WHERE passwd is not null ORDER BY usename) TO '/tmp/userlist.txt' WITH DELIMITER ' ' CSV FORCE QUOTE usename, passwd;
EOF
