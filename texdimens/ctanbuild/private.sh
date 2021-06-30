#!/bin/sh
dir="texdimens"
f="$dir/texdimens.tex"
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
   cp -f $g $f && rm $g && echo "OK."
else
   echo "ERREUR !!"  # will be triggered if last line begins with %! and no EOF
   exit 1
fi

bbb="rn"
jfbu=" ${aaa}${bbb}${ccc}"

sed -i "s/$bubu/$jfbu/g" "$dir/LICENSE.md"
sed -i "s/$bubu/$jfbu/g" "$dir/README.md"
sed -i "s/$bubu/$jfbu/g" "$dir/texdimens.tex"
sed -i "s/$bubu/$jfbu/g" "$dir/texdimens.sty"
echo "Done blowing up jfbu cover in LICENSE.md README.md texdimens.tex texdimens.sty"

# Local variables:
# coding: utf-8
# End:
