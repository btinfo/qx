#!/bin/bash -x

src1="$HOME/git/v2fly/domain-list-community/data"
src2="$HOME/git/ACL4SSR/ACL4SSR/Clash/Ruleset"
des="$HOME/git/btinfo/qx/rule"

cd $src1;git pull
cd $src2;git pull
cd $des;git pull

curl -fsL https://raw.githubusercontent.com/kokoryh/Script/master/Surge/rule/Unbreak-p.list > Unbreak-p.list
[[ -s Unbreak-p.list ]] || exit 1
curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/release/category-ads-all.txt > v2fly.txt
[[ -s v2fly.txt ]] || exit 1
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt > filter_25.txt
[[ -s filter_25.txt ]] || exit 1

ads () #https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/
{
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

true > $des/ads.txt
cd $src1
for i in $inc
do
  echo "#$i" >> $des/ads.txt
  cat $i |sed '/^$/d;/^#/d;/^regexp/d'|sed 's/^full://g'|sed 's/ @ads//g' >> $des/ads.txt
  echo "" >> $des/ads.txt
done

sed -i '/^is.snssdk.com$/d' $des/ads.txt
sed -i '$d' $des/ads.txt
}

global ()
{
#https://raw.githubusercontent.com/DivineEngine/Profiles/master/Surge/Ruleset/Global.list
#https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ProxyLite.list
cd $des
app="Github Instagram Spotify Telegram TIDAL Twitter YouTube"
true > a
for i in $app
do
  cat $src2/$i.list|grep -Ev "^$|#"|sort -u >> a
done

cat Global.list ProxyLite.list Unbreak-p.list|grep -Ev "^$|#"|sort -u > g
grep -Fvf a g > global.txt

rm -f a g
}

koads ()
{  
cd $des
cat filter_25.txt|grep '^||.*\*'|sed 's/\^//g'|sed 's/||/host-wildcard, /g'|sort -u > koads.txt
cat filter_25.txt|grep '^||'|grep -v '\*'|sed 's/\^//g'|sed 's/||/host-suffix, /g'|sort -u >> koads.txt
rm -f filter_25.txt
}

ads
global
koads
