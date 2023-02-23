#!/bin/bash -x

  cd "$(dirname "$0")" || exit
  
  ASET=(app/*.list)
  SORT=(sort -u -t',' -k1)
  
  # rule_yy
 function AA ()
 {
  grep -Ehv "^$|^#|^-" "${ASET[@]}" | grep ', reject' | sed 's/, reject//g' | "${SORT[@]}" > rule/reject.list
  grep -Ehv "^$|^#|^-" "${ASET[@]}" | grep -Ev 'reject|direct' | sed 's/, proxy//g' | "${SORT[@]}" > rule/proxy.list
  grep -Ehv "^$|^#|^-" "${ASET[@]}" | grep ', direct' | sed 's/, direct//g' | "${SORT[@]}" > rule/direct.list
  
  grep -Ehv "^$" "${ASET[@]}" | grep -E "^\^http|^\(\^http" > com_conf
  
  grep -Eh '%.*%' "${ASET[@]}" \
    | awk -F% '{print $2}' | sed 's/,/\n/g' | sed 's/ //g' | sort -u > com_host

  echo "hostname = $(sed -e '/^#/d' -e '/^$/d' -e 's/ //g' com_host \
    | sort -u | xargs | sed 's/ /,/g')" > com_host
    
  cat com_host com_conf > rw/btinfo.conf
  
  rm -f com_conf com_host
  }
  
  curl -s https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
    | grep '^||' | sed -e 's/||/host-suffix, /g' -e 's/\^//g' \
    | grep -v '\*' | sort -u > rule/koad.list
  #curl -s https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
  #  | grep '^||' | grep '\*' | sed -e 's/||/host-wildcard, /g' -e 's/\^//g' \
  #  | sort -u >> rule/koad.list
  curl -s https://raw.githubusercontent.com/DivineEngine/Profiles/master/Quantumult/Filter/Guard/Advertising.list > rule/source/Advertising.list
  curl -s https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list > rule/source/BanProgramAD.list
  curl -s https://raw.githubusercontent.com/techprober/v2ray-rules-dat/release/geosite/category-ads.txt | sort -u > rule/source/category-ads.txt
  
  src="$HOME/git/techprober/mosdns-lxc-deploy/rules/domains"
  des="$HOME/git/btinfo/qx/rule/ads.txt"

  true > "$des"
  cd "$src" || exit 1
  for i in $(ls *-ads.txt|grep -v category); do
    echo "#### $i" >> "$des"
    grep -v "regexp:" "$i" | sed 's/full://g' | sort -u >> "$des"
    echo "" >> "$des"
  done
  cd - || exit 1
  
