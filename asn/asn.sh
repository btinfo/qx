#!/bin/bash
#
sed -i 's/ $//' test
sed -i 's/\t/\/\/ /' test
sed -i 's/^AS/IP-ASN,/' test
echo "# updated at $(date --rfc-3339=seconds)" > $1
sort -V test >> $1
rm -f test
