#!/bin/bash -x

# v2fly
curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/release/category-ads-all.txt \
|sed '/^regexp/d'|cut -d: -f2|sort -u > rule/categary-ads.txt

#https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/
inc="adjust alibaba amazon apple applovin baidu bytedance flurry google jd kuaishou mopub netease tencent umeng"

true > rule/v2fly.txt
for i in $inc
do
  echo "#$i" >> rule/v2fly.txt
  curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/$i-ads \
  |sed '/^$/d;/^#/d;/^regexp/d'|sed 's/^full://g'|sed 's/ @ads//g' >> rule/v2fly.txt
  echo "" >> rule/v2fly.txt
done

sed -i "/^is.snssdk.com$/d" rule/v2fly.txt

# Korean ads
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
|grep '^||.*\*'|sed 's/\^//g'|sed 's/||/host-wildcard,/g'|sort -u >rule/koads.txt
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
|grep '^||'|grep -v '\*'|sed 's/\^//g'|sed 's/||/host-suffix,/g'|sort -u >>rule/koads.txt
