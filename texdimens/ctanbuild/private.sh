#!/bin/sh

f="texdimens.tex"
g="$f-trimmed"
aaa="Bu"
bubu=" B."
ccc="ol"

NLCOMMENT=$(grep -c ^%! $f)
NLAVANT=$(wc -l < $f)
# ls -l $f
echo "$NLCOMMENT sur $NLAVANT lignes à supprimer dans $f."
sed '/^%!/d' $f > "$g"
# ls -l $g
NLAPRES=$(wc -l < "$g")
echo "$NLAPRES lignes restantes."
NLDELTA=`expr $NLAVANT - $NLAPRES`
if [ "$NLCOMMENT" -eq "$NLDELTA" ] ; then
   cp -f $g $f && rm $g && echo "OK." && ls -l "$f"
else
   echo "ERREUR !!"  # will be triggered if last line begins with %! and no EOF
   exit 1
fi

bbb="rn"
jfbu=" ${aaa}${bbb}${ccc}"

sed -i "s/$bubu/$jfbu/g" LICENSE.md
sed -i "s/$bubu/$jfbu/g" README.md
sed -i "s/$bubu/$jfbu/g" texdimens.tex
sed -i "s/$bubu/$jfbu/g" texdimens.sty

# Local variables:
# coding: utf-8
# End:
