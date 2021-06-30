#!/bin/sh
aaa="Bu"
dir="texdimens"
bubu=" B\."

for file in texdimens.tex README.md
do
    f="$dir/$file"
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
	cp -f $g $f && rm $g && echo "OK for $f"
    else
	echo "ERREUR !!"  # will be triggered if last line begins with %! and no EOF
	exit 1
    fi
done

bbb="rn"
ccc="ol"
jfbu=" ${aaa}${bbb}${ccc}"

echo "Blowing up jfbu cover in LICENSE.md README.md texdimens.tex texdimens.sty ..."
sed -i "s/$bubu/$jfbu/g" "$dir/LICENSE.md"
sed -i "s/$bubu/$jfbu/g" "$dir/README.md"
sed -i "s/$bubu/$jfbu/g" "$dir/texdimens.tex"
sed -i "s/$bubu/$jfbu/g" "$dir/texdimens.sty"
echo "... done"

# Local variables:
# coding: utf-8
# End:
