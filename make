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
  [[ -f reject_awa ]] && rm -f reject_awa
  curl -fsL https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Ads-Rule/main/Filters/AWAvenue-Ads-Rule-QuantumultX.list > reject_awa
  [[ -s reject_awa ]] || exit

  #SukkaW
  #curl -fsL https://raw.githubusercontent.com/SukkaW/Surge/master/Source/domainset/reject_sukka.conf |grep '^\.'|sed 's/^./HOST-SUFFIX,/g'|sort -u > reject_sukka
  #curl -fsL https://raw.githubusercontent.com/SukkaW/Surge/master/Source/domainset/reject_sukka.conf |grep -Ev "^#|^\.|^$"|sed 's/^/HOST,/g'|sort -u >> reject_sukka

  #category-ads-all.txt
  curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/release/category-ads-all.txt|grep -v '^regexp:'|sed 's/:@ads$//g'|sed 's/^domain:/HOST-SUFFIX,/g'|sed 's/^full:/HOST,/g'|sort -u > reject_v2fly
  [[ -s reject_v2fly ]] || exit
  sed -i '/is.snssdk.com/d' reject_v2fly
  #sed -i '/HOST-SUFFIX,umeng.com/d' reject_v2fly
  
  #filter_25.txt
  curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt|grep '^||'|sed 's/||//g'|sed 's/\^.*//g'|sort -u > filter_25.txt
  [[ -s filter_25.txt ]] || exit
  format filter_25.txt reject_ko
  
}

format () {
  
  true > $2
  while read -r line
  do
    num=`echo $line|awk -F. '{print NF-1}'`
    if echo $line|grep '*';then
      echo "HOST-WILDCARD,$line" >> $2
    elif echo $line|grep '.co.kr';then
      [[ $num -eq 2 ]] && echo "HOST-SUFFIX,$line" >> $2
      [[ $num -gt 2 ]] && echo "HOST,$line" >> $2
    else
      [[ $num -eq 1 ]] && echo "HOST-SUFFIX,$line" >> $2
      [[ $num -gt 1 ]] && echo "HOST,$line" >> $2
    fi
  done < $1
  rm -f $1
}

all () {
  cd "$des"/rule||exit
  {
    cat <direct|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&, direct/g'
    cat <reject|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&, reject/g'
    cat <reject_k|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&, reject/g'
    #cat <reject+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&, reject/g'
    cat <proxy|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'
    cat <proxy_ko|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&, Global/g'
    cat <proxy+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&, Global/g'
    cat <direct+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&, direct/g'
  } > all
}

readme () {
  cd "$des"/rule||exit
  grep -Ecv --exclude-dir=src "^$|#" -- *|awk -F: '{print $2,$1}'|column -t > "$des"/README
}

parser
reject
#all
readme

