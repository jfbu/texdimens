# -*- fill-column: 66; sentence-end-double-space: t -*-
# 29 juin 2021
# updates on 2021/11/04 for inclusion of a texdimens.pdf in CTAN upload
docfiles    = README.md CTAN_LICENSE.md CTAN_README.md
sourcefiles = texdimens.tex texdimens.sty
TEST = 

.PHONY: test testctan ctan clean

README: README.md
	pandoc -t plain -o README README.md

# For html (if offline), let's go via reStructuredText html5 writer
# which has some minimal CSS giving satisfactory result, contrarily
# (afaict even with -s option) to pandoc html5 (but I did not insist
# much)
README.rst: README.md
	pandoc -t rst -o README.rst README.md

README.html: README.rst
	rst2html5.py README.rst README.html

# 21/11/04. Attention to leave no spaces after the backsslashes
# 21/11/13. Filter TeX/LaTeX (memo: <space>TeX no good if TeX starts paragraph)
# 21/11/15. Include commented code in pdf doc
pytexdimens.tex: texdimens.tex
	echo '\\newgeometry{hmargin=3cm}' > pytexdimens.tex
	echo '\\footnotesize' >> pytexdimens.tex
	echo '\\subsection{Implementation}' >> pytexdimens.tex
	pygmentize -S lovelace -f latex >> pytexdimens.tex
	pygmentize -o temp.tex -l tex -O linenos=true texdimens.tex
	cat temp.tex >> pytexdimens.tex
	rm temp.tex

texdimens.ltx: README.md pytexdimens.tex
	pandoc -s -t latex --toc -Vcolorlinks -Vpapersize=a4 \
	-Vfontsize=11pt -Vfontfamily=newtxtext -Vclassoption=dvipdfmx \
	-Vurlcolor=magenta -Vtoccolor=Blue -Vverbatim-in-note=true \
	-Vgeometry=pass -A pytexdimens.tex -o texdimens.ltx README.md
	@# cp texdimens.ltx texdimens-old.ltx
	sed -i 's/LaTeX/LATEX/g' texdimens.ltx
	sed -i 's/e-TeX/ETEX/g' texdimens.ltx
	sed -i 's/TeX/\\TeX{}/g' texdimens.ltx
	sed -i 's/LATEX/\\LaTeX{}/g' texdimens.ltx
	sed -i 's/ETEX/$$\\varepsilon$$-\\TeX{}/g' texdimens.ltx
	@# diff -u texdimens-old.ltx texdimens.ltx

texdimens.pdf: texdimens.ltx
	latex -halt-on-error -interaction=batchmode texdimens.ltx
	latex -halt-on-error -interaction=batchmode texdimens.ltx
	dvipdfmx texdimens.dvi

test:
	cd units && ./regressiontest.sh $(TEST)

testctan:
	cd units && ./regressiontest.sh --ctan $(TEST)

# ATTENTION à un truc comme ctanbuild/$(sourcefiles) !
# le ctanbuild/ ne s'applique qu'au premier !
texdimens.zip: $(docfiles) $(sourcefiles) ctanbuild/private.sh ctanbuild/maketexdimenspdf.sh
	@echo 'Removing CTAN/texdimens.zip if it exists!'
	rm -fr CTAN/texdimens.zip
	rm -fr                ctanbuild/texdimens
	rm -f                 ctanbuild/texdimens.zip
	mkdir -p              ctanbuild/texdimens
	chmod ugo+rwx         ctanbuild/texdimens
	cp -a $(docfiles)     ctanbuild/texdimens
	cp -a $(sourcefiles)  ctanbuild/texdimens
	cd ctanbuild && ./private.sh
	cd ctanbuild && ./maketexdimenspdf.sh
	chmod -R ugo+r        ctanbuild/texdimens
	ls -al                ctanbuild/texdimens
	umask 0022 && cd ctanbuild && zip -r texdimens.zip texdimens
	@echo 'Test coverage is not enough, improve that!'
	@echo 'Now executing the few unit tests we have'
	cd units && ./regressiontest.sh --ctan
	mv ctanbuild/texdimens.zip CTAN/
	@echo '********'
	@echo 'new texdimens.zip done and moved to CTAN/ directory.'
	@echo '********'

ctan: texdimens.zip

clean:
	rm -f texdimens.dvi
	rm -f texdimens.aux
	rm -f texdimens.log
	rm -f texdimens.out
	rm -f texdimens.ltx
	rm -f texdimens.toc
