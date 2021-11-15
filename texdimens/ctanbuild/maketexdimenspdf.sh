#!/bin/bash
# memo: using bash for the -n to echo

cd texdimens
echo "Producing texdimens.pdf for CTAN ..."
echo -n "(pygmentize ..."
echo '\footnotesize' > pytexdimens.tex
echo '\subsection{Implementation}' >> pytexdimens.tex
pygmentize -S lovelace -f latex >> pytexdimens.tex
pygmentize -o temp.tex -l tex texdimens.tex
cat temp.tex >> pytexdimens.tex
rm temp.tex
echo "done)"
echo -n "(pandoc ... "
pandoc -s -t latex --toc -Vcolorlinks -Vpapersize=a4 \
	-Vfontsize=11pt -Vfontfamily=newtxtext -Vclassoption=dvipdfmx \
	-Vurlcolor=magenta -Vtoccolor=Blue -Vverbatim-in-note=true \
	-Vgeometry=a4paper -A pytexdimens.tex -o README.tex README.md
rm pytexdimens.tex
sed -i 's/LaTeX/LATEX/g' README.tex
sed -i 's/e-TeX/ETEX/g' README.tex
sed -i 's/TeX/\\TeX{}/g' README.tex
sed -i 's/LATEX/\\LaTeX{}/g' README.tex
sed -i 's/ETEX/$\\varepsilon$-\\TeX{}/g' README.tex
echo "done)"
latex -halt-on-error -interaction=batchmode README.tex
latex -halt-on-error -interaction=batchmode README.tex
dvipdfmx README.dvi
mv README.pdf texdimens.pdf
mv README.md texdimens.md
rm README*
mv CTAN_README.md README.md
mv CTAN_LICENSE.md LICENSE.md
echo "... done"
echo "auxiliary files removed, README.md renamed texdimens.md"
echo "CTAN_README.md renamed into README.md"
echo "CTAN_LICENSE.md renamed into LICENSE.md"

# Local variables:
# coding: utf-8
# End:
