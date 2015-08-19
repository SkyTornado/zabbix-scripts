#!/bin/bash
abdb() {
    abdb_arg=$1
    /usr/bin/mysql -N -u tornado --password=fkg7h4f3v6 --default-character-set=latin1 -h 192.168.8.34 --database="abills" --execute="$abdb_arg;"
}

ip=$1
net=`echo $ip | awk -F. '{print $2}'`

if [[ $net = '70' || $net = '170' ]]
then
    info=`abdb "select descr from nas where ip='$ip'"`
else
    info=`abdb "select us.id, pi.fio, pi.city, pi.address_street, pi.address_build, \
    ifnull((select ns.ip from nas ns, users_nas un where id=un.nas_id and dh.uid=un.uid),'NO NAS!'), dh.comments, dh.ports \
    from users_pi pi, users us, dhcphosts_hosts dh \
    where dh.ip=inet_aton('$ip') and us.uid=dh.uid and pi.uid=dh.uid"`
fi

info=$(echo $info | /usr/bin/iconv -f cp1251 -t utf-8)
echo  $info
