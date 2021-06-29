#!/bin/sh

f="texdimens.tex"
g="$f-trimmed"

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
   echo "ERREUR !!"
   exit 1
fi

# Local variables:
# coding: utf-8
# End:
