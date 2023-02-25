#!/bin/bash -x

curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt |grep '^||'|sed 's/||/host-suffix, /g'|sed 's/\^//g'|grep -v '\*'|sort -u > rule/koad.txt

## category-ads.txt
#curl -fsL https://raw.githubusercontent.com/techprober/mosdns-lxc-deploy/master/rules/domains/category-ads.txt |sed '/^regexp:/d'|sed 's/^full://g'|sort -u > rule/ads.txt

curl -fsL https://raw.githubusercontent.com/Loyalsoldier/domain-list-custom/release/category-ads-all.txt |sed '/^regexp/d'|cut -d: -f2|sort -u > rule/ads.txt
