echo 'alias nocomments="sed -e :a -re '"'"'s/<!--.*?-->//g;/<!--/N;//ba'"'"' | grep -v -P '"'"'^\s*(#|;|$)'"'"'"' >> ~/.bashrc
source ~/.bashrc

ls -la /dev/sd*
vgs --units m -o vg_name,pv_name,pv_size,pv_free
lvs --units m -o vg_name,lv_name,origin,lv_size,data_percent,mirror_log,devices
pvs --units m -o pv_name,pv_size,pv_free

# fdisk /dev/sdb
# fdisk /dev/sdc

pvcreate /dev/sdb1
pvcreate /dev/sdc1
vgcreate postgresql_data_vg /dev/sdb1
vgcreate postgresql_wal_vg /dev/sdc1
lvcreate -n pg_data -l 100%FREE postgresql_data_vg
lvcreate -n pg_wal -l 100%FREE postgresql_wal_vg

mkfs.xfs /dev/postgresql_data_vg/pg_data
mkfs.xfs /dev/postgresql_wal_vg/pg_wal

mkdir /pg_data
mkdir /pg_wal

echo "/dev/postgresql_data_vg/pg_data /pg_data xfs defaults        0 0" >> /etc/fstab
echo "/dev/postgresql_wal_vg/pg_wal   /pg_wal  xfs defaults        0 0" >> /etc/fstab

cat /etc/fstab | nocomments | grep postgres

#nano /etc/fstab

mount -a

df -hT | grep -v "devtmpfs\|tmpfs\|squashfs"

vgs --units m -o vg_name,pv_name,pv_size,pv_free

lvs --units m -o vg_name,lv_name,origin,lv_size,data_percent,mirror_log,devices
