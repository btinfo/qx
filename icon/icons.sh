echo > $1.json
for i in `ls $1`
  do echo "{"name":"$i","url":"https://raw.githubusercontent.com/btinfo/qx/main/icon/$1/$i"}," >> $1.json
done

