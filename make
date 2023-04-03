#!/bin/bash -x

src="$HOME/git/v2fly/domain-list-community/data"
des="$HOME/git/btinfo/qx/rule"

cd "$src"||exit;git pull
#cd $des;git pull

cd "$des"||exit
curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/release/category-ads-all.txt|sed '/^regexp/d'|cut -d: -f2|sort -u > src/reject_v2fly_all
[[ -s src/reject_v2fly_all ]] || exit 1
curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt > filter_25.txt
[[ -s filter_25.txt ]] || exit 1

parser () {
cd "$des"/../js||exit
curl -fsL https://raw.githubusercontent.com/KOP-XIAO/QuantumultX/master/Scripts/resource-parser.js > resource-parser.js
[[ -s resource-parser.js ]] || exit
patch -p0 < patch.txt
}

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
grep '^||.*\*' filter_25.txt|sed 's/\^//g'|sed 's/||/HOST-WILDCARD,/g'|sort -u > src/reject_ko_origin
grep '^||' filter_25.txt|grep -v '\*'|sed 's/\^//g'|sed 's/||/HOST-SUFFIX,/g'|sort -u >> src/reject_ko_origin
rm -f filter_25.txt
}

all () {
  cd "$des"||exit
  {
    cat <direct_pin|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,DIRECT/g'
    cat <reject+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,REJECT/g'
    cat <reject_ko|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,REJECT/g'
    cat <proxy_apps|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'
    cat <proxy+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,Global/g'
    cat <direct+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,DIRECT/g'
  } > all
}

readme () {
cd "$des"||exit
grep -Ecv --exclude-dir=src "^$|#" -- *|awk -F: '{print $2,$1}'|column -t >../README
}

parser
reject_v2fly
reject_ko_origin
all
readme

