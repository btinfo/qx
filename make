#!/bin/bash -x

des="$HOME/git/btinfo/qx"

parser () {
  cd "$des"/js||exit
  curl -fsL https://raw.githubusercontent.com/KOP-XIAO/QuantumultX/master/Scripts/resource-parser.js > resource-parser.js
  [[ -s resource-parser.js ]] || exit
  patch -p0 < patch.txt
}

reject () {
  cd "$des"/rule||exit
  
  #AWAvenue-Ads-Rule
  curl -fsL https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Ads-Rule/main/AWAvenue-Ads-Rule-AdClose.txt|sed '/^\/\//d'|sed '/^\s$/d'|sed '/\//d' > awavenue-ads
  grep '\*' awavenue-ads|sed 's/^/HOST-WILDCARD,/g' > reject_awa
  grep -v '\*' awavenue-ads|sed 's/^/HOST-SUFFIX,/g' >> reject_awa
  sed -i '/mp.weixin.qq.com/d' reject_awa
  rm -f awavenue-ads

  #SukkaW
  curl -fsL https://raw.githubusercontent.com/SukkaW/Surge/master/Source/domainset/reject_sukka.conf |grep '^\.'|sed 's/^./HOST-SUFFIX,/g' > reject_sukka
  curl -fsL https://raw.githubusercontent.com/SukkaW/Surge/master/Source/domainset/reject_sukka.conf |grep -Ev "^#|^\.|^$"|sed 's/^/HOST,/g' >> reject_sukka

  #category-ads-all.txt
  curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/release/category-ads-all.txt \
  |sed '/^regexp/d'|sed 's/:@ads$//g'|sed 's/^domain:/HOST-SUFFIX,/g'|sed 's/^full:/HOST,/g'|sort -u > reject_v2fly
  [[ -s reject_v2fly ]] || exit
  sed -i '/is.snssdk.com/d' reject_v2fly
  sed -i '/HOST-SUFFIX,umeng.com/d' reject_v2fly
  
  #3rd_domains.txt
  curl -fsL https://raw.githubusercontent.com/List-KR/List-KR/master/filters-share/3rd_domains.txt > 3rd_domains.txt
  [[ -s 3rd_domains.txt ]] || exit
  grep '^||.*\*' 3rd_domains.txt|sed 's/\^.*//g'|sed 's/||/HOST-WILDCARD,/g'|sort -u > 3rd_domains
  grep '^||' 3rd_domains.txt|grep -v '\*'|sed 's/\^.*//g'|sed 's/||/HOST,/g'|sort -u >> 3rd_domains
  
  #1st_domains.txt
  curl -fsL https://raw.githubusercontent.com/List-KR/List-KR/master/filters-share/1st_domains.txt > 1st_domains.txt
  [[ -s 1st_domains.txt ]] || exit
  grep '^||.*\*' 1st_domains.txt|sed 's/\^.*//g'|sed 's/||/HOST-WILDCARD,/g'|sort -u > 1st_domains
  grep '^||' 1st_domains.txt|grep -v '\*'|sed 's/\^.*//g'|sed 's/||/HOST-SUFFIX,/g'|sort -u >> 1st_domains

  cat 3rd_domains 1st_domains | sort -u > reject_ko
  rm -f 3rd_domains* 1st_domains*

  #merge
  #cat sukkaw 1st_domains 3rd_domains |sort -u > reject
  
}
  
all () {
  cd "$des"/rule||exit
  {
    cat <direct|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,DIRECT/g'
    cat <reject|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,REJECT/g'
    cat <reject+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,REJECT/g'
    cat <proxy|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'
    cat <proxy_ko|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,Global/g'
    cat <proxy+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,Global/g'
    cat <direct+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,DIRECT/g'
  } > all
}

readme () {
  cd "$des"/rule||exit
  grep -Ecv --exclude-dir=src "^$|#" -- *|awk -F: '{print $2,$1}'|column -t > "$des"/README
}

parser
reject
all
readme

