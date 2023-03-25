#!/bin/bash -x

src="$HOME/git/v2fly/domain-list-community/data"
des="$HOME/git/btinfo/qx/rule"

cd "$src"||exit;git pull
#cd $des;git pull

cd "$des"||exit
curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/release/category-ads-all.txt|sed '/^regexp/d'|cut -d: -f2 > src/reject_v2fly_all
[[ -s src/reject_v2fly_all ]] || exit 1
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt > filter_25.txt
[[ -s filter_25.txt ]] || exit 1

reject_v2fly ()
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

true > "$des"/src/reject_v2fly
cd "$src"||exit
for i in $inc
do
  echo "#$i" >> "$des"/src/reject_v2fly
  sed '/^$/d;/^#/d;/^regexp/d' "$i"|sed 's/^full://g'|sed 's/ @ads//g' >> "$des"/src/reject_v2fly
  echo "" >> "$des"/src/reject_v2fly
done

sed -i '/^is.snssdk.com$/d' "$des"/src/reject_v2fly

}

reject_ko_origin ()
{  
cd "$des"||exit
grep '^||.*\*' filter_25.txt|sed 's/\^//g'|sed 's/||/host-wildcard,/g'|sort -u > src/reject_ko_origin
grep '^||' filter_25.txt|grep -v '\*'|sed 's/\^//g'|sed 's/||/host-suffix,/g'|sort -u >> src/reject_ko_origin
rm -f filter_25.txt
}

readme () {
cd $des||exit
grep -Ecv --exclude-dir=src "^$|#" *|awk -F: '{print $2,$1}'|column -t >../README
}

reject_v2fly
reject_ko_origin
readme

