#!/bin/bash

  cd "$(dirname "$0")" || exit
  
  ASET=(app/*.list)
  SORT=(sort -u -t',' -k1)
  
  # rule_yy
 
  grep -Ehv "^$|^#" "${ASET[@]}" | grep 'REJECT' | sed 's/,REJECT//g' | "${SORT[@]}" > rule/reject.list
  grep -Ehv "^$|^#" "${ASET[@]}" | grep 'PROXY' | sed 's/,PROXY//g' | "${SORT[@]}" > rule/proxy.list
  grep -Ehv "^$|^#" "${ASET[@]}" | grep 'DIRECT' | sed 's/,DIRECT//g' | "${SORT[@]}" > rule/direct.list
  
  #grep -Ehv "^$|^#" "${ASET[@]}" | grep 'REJECT' | "${SORT[@]}" > rule/reject.list
  #grep -Ehv "^$|^#" "${ASET[@]}" | grep 'PROXY' | "${SORT[@]}" > rule/proxy.list
  #grep -Ehv "^$|^#" "${ASET[@]}" | grep 'DIRECT' | "${SORT[@]}" > rule/direct.list
  
  grep -Ehv "^$" "${ASET[@]}" | grep -E "^\^http|^\(\^http" > com_conf
  
  grep -Eh '%.*%' "${ASET[@]}" \
    | awk -F% '{print $2}' | sed 's/,/\n/g' | sed 's/ //g' | sort -u > com_host

  echo "hostname = $(sed -e '/^#/d' -e '/^$/d' -e 's/ //g' com_host \
    | sort -u | xargs | sed 's/ /,/g')" > com_host
    
  cat com_host com_conf > rw/com.conf
  
  rm -f com_conf com_host
  
  curl -s https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
    | grep '^||' | sed -e 's/||/host-suffix, /g' -e 's/\^//g' \
    | grep -v '\*' | sort -u > rule/koad.list
  #curl -s https://adguardteam.github.io/HostlistsRegistry/assets/filter_25.txt \
  #  | grep '^||' | grep '\*' | sed -e 's/||/host-wildcard, /g' -e 's/\^//g' \
  #  | sort -u >> rule/koad.list

