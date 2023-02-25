#!/bin/bash
#

sed -i 's/\t/\/\/ /' test
sed -i 's/^AS/IP-ASN,/' test
sed -i 's/ $//' test
echo "# $(date --rfc-3339=seconds)" > $1
sort -V test >> $1
rm -f test
