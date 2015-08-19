#!/bin/bash
abdb() {
    abdb_arg=$1
    /usr/bin/mysql -N -u tornado --password=fkg7h4f3v6 --default-character-set=latin1 -h 192.168.8.34 --database="abills" --execute="$abdb_arg;"
}

ip=$1

    info=`abdb "select dhcphosts_hosts.mac from dhcphosts_hosts,users_pi,dv_main where dhcphosts_hosts.ip=inet_aton('$ip') and users_pi.uid = dhcphosts_hosts.uid and users_pi.uid=dv_main.uid and dv_main.uid=users_pi.uid"`

if [ "$info" == ""  ]; then
info=0
fi

info=$(echo $info | /usr/bin/iconv -f cp1251 -t utf-8)
echo  $info
