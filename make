#!/bin/bash -x

# v2fly
curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/release/category-ads-all.txt \
|sed '/^regexp/d'|cut -d: -f2|sort -u > rule/v2fly.txt

#https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/
inc="
adjust-ads \
alibaba-ads \
amazon-ads \
apple-ads \
applovin-ads \
baidu-ads \
bytedance-ads \
flurry-ads \
google-ads \
growingio-ads \
jd-ads \
kuaishou-ads \
mopub-ads \
netease-ads \
taboola \
tencent-ads \
umeng-ads
"

true > rule/ads.txt
for i in $inc
do
  echo "#$i" >> rule/ads.txt
  curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/$i \
  |sed '/^$/d;/^#/d;/^regexp/d'|sed 's/^full://g'|sed 's/ @ads//g' >> rule/ads.txt
  echo "" >> rule/ads.txt
done

sed -i '/^is.snssdk.com$/d' rule/ads.txt
# Korean ads
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
|grep '^||.*\*'|sed 's/\^//g'|sed 's/||/host-wildcard, /g'|sort -u >rule/koads.txt
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
|grep '^||'|grep -v '\*'|sed 's/\^//g'|sed 's/||/host-suffix, /g'|sort -u >>rule/koads.txt
