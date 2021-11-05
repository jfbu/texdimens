# -*- fill-column: 66; sentence-end-double-space: t -*-
# 29 juin 2021
# updates on 2021/11/04 for inclusion of a texdimens.pdf in CTAN upload
docfiles    = README.md LICENSE.md CTAN_README.md
sourcefiles = texdimens.tex texdimens.sty
TEST = 

.PHONY: test testctan ctan clean

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
