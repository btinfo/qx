#!/bin/bash

  cd "$(dirname "$0")" || exit
  
  ASET=(app/*.list)
  SORT=(sort -u -t',' -k1)
  
  # rule_yy
 
  #grep -Ehv "^$|^#" "${ASET[@]}" | grep 'REJECT' | sed 's/,REJECT//g' | "${SORT[@]}" > rule/reject.list
  #grep -Ehv "^$|^#" "${ASET[@]}" | grep 'PROXY' | sed 's/,PROXY//g' | "${SORT[@]}" > rule/proxy.list
  #grep -Ehv "^$|^#" "${ASET[@]}" | grep 'DIRECT' | sed 's/,DIRECT//g' | "${SORT[@]}" > rule/direct.list
  
  grep -Ehv "^$|^#" "${ASET[@]}" | grep 'REJECT' | "${SORT[@]}" > rule/reject.list
  grep -Ehv "^$|^#" "${ASET[@]}" | grep 'PROXY' | "${SORT[@]}" > rule/proxy.list
  grep -Ehv "^$|^#" "${ASET[@]}" | grep 'DIRECT' | "${SORT[@]}" > rule/direct.list
  
  grep -Ehv "^$" "${ASET[@]}" | grep -E "^\^http|^\(\^http" > app_conf
  
  grep -Eh '%.*%' "${ASET[@]}" \
    | awk -F% '{print $2}' | sed 's/,/\n/g' | sed 's/ //g' | sort -u > host_app

  echo "hostname = $(sed -e '/^#/d' -e '/^$/d' -e 's/ //g' host_app \
    | sort -u | xargs | sed 's/ /,/g')" > host_app
    
  cat host_app app_conf > rewrite/app.conf
  
  rm -f app_conf host_app

