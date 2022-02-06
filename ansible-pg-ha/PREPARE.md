echo 'alias nocomments="sed -e :a -re '"'"'s/<!--.*?-->//g;/<!--/N;//ba'"'"' | grep -v -P '"'"'^\s*(#|;|$)'"'"'"' >> ~/.bashrc<BR>
source ~/.bashrc<BR>

ls -la /dev/sd*<BR>
vgs --units m -o vg_name,pv_name,pv_size,pv_free<BR>
lvs --units m -o vg_name,lv_name,origin,lv_size,data_percent,mirror_log,devices<BR>
pvs --units m -o pv_name,pv_size,pv_free<BR>

fdisk /dev/sdb<BR>
fdisk /dev/sdc<BR>

pvcreate /dev/sdb1<BR>
pvcreate /dev/sdc1<BR>
vgcreate postgresql_data_vg /dev/sdb1<BR>
vgcreate postgresql_wal_vg /dev/sdc1<BR>
lvcreate -n pg_data -l 100%FREE postgresql_data_vg<BR>
lvcreate -n pg_wal -l 100%FREE postgresql_wal_vg<BR>

mkfs.xfs /dev/postgresql_data_vg/pg_data<BR>
mkfs.xfs /dev/postgresql_wal_vg/pg_wal<BR>

mkdir /pg_data<BR>
mkdir /pg_wal<BR>

echo "/dev/postgresql_data_vg/pg_data /pg_data xfs defaults        0 0" >> /etc/fstab<BR>
echo "/dev/postgresql_wal_vg/pg_wal   /pg_wal  xfs defaults        0 0" >> /etc/fstab<BR>

cat /etc/fstab | nocomments | grep postgres<BR>

#nano /etc/fstab<BR>

mount -a<BR>

df -hT | grep -v "devtmpfs\|tmpfs\|squashfs"<BR>

vgs --units m -o vg_name,pv_name,pv_size,pv_free<BR>

lvs --units m -o vg_name,lv_name,origin,lv_size,data_percent,mirror_log,devices<BR>

