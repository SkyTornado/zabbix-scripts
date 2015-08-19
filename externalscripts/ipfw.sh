#!/bin/bash

abget() {
abger_agr=$1
/usr/bin/mysql -N -u tornado --password=fkg7h4f3v6 --default-character-set=latin1 -h 192.168.8.34 --database="abills" --execute="$abger_agr"
}

billist=`abget "select inet_ntoa(dv_main.ip) from users, users_pi, dhcphosts_hosts, bills, users_nas, dv_main where users_pi.uid = dhcphosts_hosts.uid and users_nas.uid=users_pi.uid and users_pi.uid=bills.uid AND users.id = dhcphosts_hosts.hostname and dv_main.uid=users_pi.uid and bills.deposit > 0 and users.disable =0 and dhcphosts_hosts.disable = 0 and inet_ntoa(dv_main.ip) LIKE '10.12%' or users_pi.uid = dhcphosts_hosts.uid and users_nas.uid=users_pi.uid and users_pi.uid=bills.uid AND users.id = dhcphosts_hosts.hostname and dv_main.uid=users_pi.uid and bills.deposit > 0 and users.disable =0 and dhcphosts_hosts.disable = 0 and inet_ntoa(dv_main.ip) LIKE '10.10.11.%'"`
billist="$billist `abget "select inet_ntoa(dv_main.ip) from users, users_pi, dhcphosts_hosts, bills, users_nas, dv_main where users_pi.uid = dhcphosts_hosts.uid and users_nas.uid=users_pi.uid and users_pi.uid=bills.uid and users.id = dhcphosts_hosts.hostname and dv_main.uid=users_pi.uid and bills.deposit < 0 and users.credit > 0 and users.credit > bills.deposit*(-1)  and users.disable =0  and dhcphosts_hosts.disable = 0 and inet_ntoa(dv_main.ip) LIKE '10.12%' or users_pi.uid = dhcphosts_hosts.uid and users_nas.uid=users_pi.uid and users_pi.uid=bills.uid and users.id = dhcphosts_hosts.hostname and dv_main.uid=users_pi.uid and bills.deposit < 0 and users.credit > 0 and users.credit > bills.deposit*(-1)  and users.disable =0  and dhcphosts_hosts.disable = 0 and inet_ntoa(dv_main.ip) LIKE '10.10.11.%'"`"
billist="$billist `abget "select inet_ntoa(dv_main.ip) from users, users_pi, dhcphosts_hosts, bills, users_nas, dv_main where users_pi.uid = dhcphosts_hosts.uid and users_nas.uid=users_pi.uid and users_pi.uid=bills.uid and users.id = dhcphosts_hosts.hostname and dv_main.uid=users_pi.uid and bills.deposit = 0 and users.credit >= 0  and users.disable =0  and dhcphosts_hosts.disable = 0 and inet_ntoa(dv_main.ip) LIKE '10.12%' or users_pi.uid = dhcphosts_hosts.uid and users_nas.uid=users_pi.uid and users_pi.uid=bills.uid and users.id = dhcphosts_hosts.hostname and dv_main.uid=users_pi.uid and bills.deposit = 0 and users.credit >= 0  and users.disable =0  and dhcphosts_hosts.disable = 0 and inet_ntoa(dv_main.ip) LIKE '10.12%' or users_pi.uid = dhcphosts_hosts.uid and users_nas.uid=users_pi.uid and users_pi.uid=bills.uid and users.id = dhcphosts_hosts.hostname and dv_main.uid=users_pi.uid and bills.deposit = 0 and users.credit >= 0  and users.disable =0  and dhcphosts_hosts.disable = 0 and inet_ntoa(dv_main.ip) LIKE '10.12%' or users_pi.uid = dhcphosts_hosts.uid and users_nas.uid=users_pi.uid and users_pi.uid=bills.uid and users.id = dhcphosts_hosts.hostname and dv_main.uid=users_pi.uid and bills.deposit = 0 and users.credit >= 0  and users.disable =0  and dhcphosts_hosts.disable = 0 and inet_ntoa(dv_main.ip) LIKE '10.10.11.%'"`"
fwlist=`ssh tornado@192.168.8.9 sudo ipfw table 3 list | grep -E '10\.12|10\.10\.11\.' | awk '{print $1}'`

index=0
for item in $billist; do
	item=$item/32
	listnew[$index]="$item"
	index=$((index+1))
done
for item in $fwlist; do
	listnew[$index]="$item"
	index=$((index+1))
done


IFS=$'\n' listtmp=($(sort <<<"${listnew[*]}"))
listsort=`printf "${listtmp[*]}" | grep -v "\.93\." | uniq -u`

index=0
for item in $listsort; do
	donelist[$index]="$item"
	index=$((index+1))
done

index=0
for item1 in ${donelist[*]}; do
	for item2 in $fwlist; do
		if [ $item1 == $item2 ]; then
			unset donelist[$index]
		fi
	done
	index=$((index+1))
done

printf "${donelist[*]}" 
printf "${donelist[*]}"  >  ipfw/ipfwout
