# -*- fill-column: 66; sentence-end-double-space: t -*-
# 29 juin 2021
# updates on 2021/11/04 for inclusion of a texdimens.pdf in CTAN upload
docfiles    = README.md LICENSE.md
sourcefiles = texdimens.tex texdimens.sty
TEST = 

.PHONY: test testctan ctan

README: README.md
	pandoc -t plain -o README README.md

# added 21/11/02 but I will have to check options
README.html: README.md
	pandoc -t html -o README.html README.md

# 21/11/04. Attention to leave no spaces after the backsslashes
texdimens.ltx: README.md
	pandoc -s -t latex --toc -Vcolorlinks -Vpapersize=a4 \
	-Vfontsize=11pt -Vfontfamily=newtxtext -Vclassoption=dvipdfmx \
	-Vurlcolor=magenta -Vtoccolor=Blue -o texdimens.ltx README.md

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
	mv ctanbuild/texdimens.zip CTAN/
	@echo '********'
	@echo 'texdimens.zip done and moved to CTAN/ directory.'
	@echo ''
	@echo 'This project issued a note during release build:'
	@echo '        no tests done, please fix this!'
	@echo '********'
	@# cd units && ./regressiontest.sh --ctan

ctan: texdimens.zip

