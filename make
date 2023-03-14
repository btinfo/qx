#!/bin/bash -x

# Loyalsoldier ads
curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/release/category-ads-all.txt \
|sed '/^regexp/d'|cut -d: -f2|sort -u > rule/ads.txt

exclude="dmm-ads hunantv-ads kugou-ads letv-ads xiaomitv-ads youku-ads"
true > rule/b
for i in $exclude
do
  curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/$i \
  |sed '/^regexp/d'|sed 's/ @ads//g'|sort -u >> rule/b
done

for i in $(cat rule/b)
do
  sed -i "/^$i/d" rule/ads.txt
done

sed -i '/^is.snssdk.com$/d' rule/ads.txt
rm -f rule/b

# Korean ads
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
|grep '^||.*\*'|sed 's/\^//g'|sed 's/||/host-wildcard,/g'|sort -u >rule/koads.txt
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
|grep '^||'|grep -v '\*'|sed 's/\^//g'|sed 's/||/host-suffix,/g'|sort -u >>rule/koads.txt
