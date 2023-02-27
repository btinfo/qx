#!/bin/bash -x

# Loyalsoldier ads
curl -fsL https://raw.githubusercontent.com/Loyalsoldier/domain-list-custom/release/category-ads-all.txt |sed '/^regexp/d'|cut -d: -f2|sort -u > rule/ads.txt

# Korean ads
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt|grep '^||.*\*'|sed 's/\^//g'|sed 's/||/host-wildcard,/g'|sort -u >rule/koad.txt
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt|grep '^||'|grep -v '\*'|sed 's/\^//g'|sed 's/||/host-suffix,/g'|sort -u >>rule/koad.txt
