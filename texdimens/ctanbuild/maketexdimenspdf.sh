#!/bin/bash
# memo: using bash for the -n to echo

cd texdimens
echo "Producing texdimens.pdf for CTAN ..."
echo -n "(pandoc ... "
pandoc -s -t latex --toc -Vcolorlinks -Vpapersize=a4 \
	-Vfontsize=11pt -Vfontfamily=newtxtext -Vclassoption=dvipdfmx \
	-Vurlcolor=magenta -Vtoccolor=Blue -o README.tex README.md
echo "done)"
latex -halt-on-error -interaction=batchmode README.tex
latex -halt-on-error -interaction=batchmode README.tex
dvipdfmx README.dvi
mv README.pdf texdimens.pdf
mv README.md texdimens.md
rm README*
mv CTAN_README.md README.md
echo "... done"
echo "auxiliary files removed, README.md renamed texdimens.md"
echo "and CTAN_README.md renamed into README.md"

# Local variables:
# coding: utf-8
# End:
