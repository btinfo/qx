#!/bin/bash -x

des="$HOME/git/btinfo/qx"

parser () {
  cd "$des"/js||exit
  curl -fsL https://raw.githubusercontent.com/KOP-XIAO/QuantumultX/master/Scripts/resource-parser.js > resource-parser.js
  [[ -s resource-parser.js ]] || exit
  patch -p0 < patch.txt
}

reject_v2fly () {
  cd "$des"/rule||exit
  curl -fsL https://raw.githubusercontent.com/v2fly/domain-list-community/release/category-ads-all.txt|sed '/^regexp/d'|cut -d: -f2|sort -u > reject_v2fly
  [[ -s reject_v2fly ]] || exit
  sed -i '/^is.snssdk.com$/d' reject_v2fly
}

reject_ko ()
{  
  cd "$des"/rule||exit
  curl -fsL https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt > filter_25.txt
  [[ -s filter_25.txt ]] || exit
  #grep '^||.*\*' filter_25.txt|sed 's/\^//g'|sed 's/||/HOST-WILDCARD,/g'|sort -u > reject_ko
  grep '^||.*\*' filter_25.txt|sed 's/\^//g'|sed 's/||//g'|sort -u > reject_ko
  #grep '^||' filter_25.txt|grep -v '\*'|sed 's/\^//g'|sed 's/||/HOST-SUFFIX,/g'|sort -u >> reject_ko
  grep '^||' filter_25.txt|grep -v '\*'|sed 's/\^//g'|sed 's/||//g'|sort -u >> reject_ko
  rm -f filter_25.txt
}

reject_vk ()
{
  cd "$des"/rule||exit
  cat reject_v2fly reject_ko |sort -u > reject_vk_o
  true > reject_vk
  while read -r line
  do
    num=`echo $line|awk -F. '{print NF-1}'`
    if echo $line|grep '*';then
      echo "HOST-WILDCARD,$line" >> reject_vk
    elif echo $line|grep '.co.kr';then
      [[ $num -eq 2 ]] && echo "HOST-SUFFIX,$line" >> reject_vk
      [[ $num -gt 2 ]] && echo "HOST,$line" >> reject_vk
    else
      [[ $num -eq 1 ]] && echo "HOST-SUFFIX,$line" >> reject_vk
      [[ $num -gt 1 ]] && echo "HOST,$line" >> reject_vk
    fi
  done < reject_vk_o
  rm -f reject_v2fly reject_ko reject_vk_o
}
  

all () {
  cd "$des"/rule||exit
  {
    cat <direct|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,DIRECT/g'
    cat <reject|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,REJECT/g'
    cat <reject_ko|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,REJECT/g'
    cat <proxy|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'
    cat <proxy+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,Global/g'
    cat <direct+|grep -Ev "^$|^#"|sed 's/ \/\/.*//g'|sed 's/$/&,DIRECT/g'
  } > all
}

readme () {
  cd "$des"/rule||exit
  grep -Ecv --exclude-dir=src "^$|#" -- *|awk -F: '{print $2,$1}'|column -t > "$des"/README
}

#parser
reject_v2fly
reject_ko
reject_vk
#all
#readme

