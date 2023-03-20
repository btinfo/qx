#!/bin/bash -x

# v2fly

v2fly ()
{
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

# ads.txt
true > rule/ads.txt
for i in $inc
do
  echo "#$i" >> rule/ads.txt
  curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/$i \
  |sed '/^$/d;/^#/d;/^regexp/d'|sed 's/^full://g'|sed 's/ @ads//g' >> rule/ads.txt
  echo "" >> rule/ads.txt
done

sed -i '/^is.snssdk.com$/d' rule/ads.txt
sed -i '$d' rule/ads.txt
}

global ()
{
# global.txt 
#https://raw.githubusercontent.com/DivineEngine/Profiles/master/Surge/Ruleset/Global.list
#https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ProxyLite.list
curl -fsL https://raw.githubusercontent.com/kokoryh/Script/master/Surge/rule/Unbreak-p.list > rule/Unbreak-p.list

app="Github Instagram Spotify Telegram TIDAL Twitter Youtube"
true > rule/a
for i in $app
do
  curl -fsL https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Ruleset/$i.list|grep -Ev "^$|#"|sort -u >> rule/a
done

cat rule/Global.list rule/ProxyLite.list rule/Unbreak-p.list|grep -Ev "^$|#"|sort -u > rule/g
grep -Fvf rule/a rule/g > rule/global.txt

rm -f rule/a rule/g
}

koads ()
{  
# koads.txt
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
|grep '^||.*\*'|sed 's/\^//g'|sed 's/||/host-wildcard, /g'|sort -u >rule/koads.txt
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
|grep '^||'|grep -v '\*'|sed 's/\^//g'|sed 's/||/host-suffix, /g'|sort -u >>rule/koads.txt
}

#v2fly
global
#koads
