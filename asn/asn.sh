#!/bin/bash
#

sed -i 's/\t/\/\/ /' test
sed -i 's/^AS/IP-ASN,/' test
sed -i 's/ $//' test
echo "# $(date --rfc-3339=seconds)" > $1
sort -V test >> $1
if [[ "$1" = "china" ]]; then
  echo "host-suffix,cn" >> $1
else
  echo "host-suffix,kr" >> $1
fi
rm -f test
