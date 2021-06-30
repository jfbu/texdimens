# -*- fill-column: 66; sentence-end-double-space: t -*-
# 29 juin 2021
#
docfiles    = README.md LICENSE.md
sourcefiles = texdimens.tex texdimens.sty
TEST = 

.PHONY: test testctan ctan

README: README.md
	pandoc -t plain -o README README.md

test:
	cd units && ./regressiontest.sh $(TEST)

testctan:
	cd units && ./regressiontest.sh --ctan $(TEST)

# ATTENTION à un truc comme ctanbuild/$(sourcefiles) !
# le ctanbuild/ ne s'applique qu'au premier !
texdimens.zip: $(docfiles) $(sourcefiles) ctanbuild/private.sh
	rm -fr                ctanbuild/texdimens
	rm -f                 ctanbuild/texdimens.zip
	mkdir -p              ctanbuild/texdimens
	chmod ugo+rwx         ctanbuild/texdimens
	cp -a $(docfiles)     ctanbuild/texdimens
	cp -a $(sourcefiles)  ctanbuild/texdimens
	cd ctanbuild && ./private.sh
	chmod -R ugo+r        ctanbuild/texdimens
	ls -al                ctanbuild/texdimens
	umask 0022 && cd ctanbuild && zip -r texdimens.zip texdimens
	@echo 'texdimens.zip done.'
	@echo 'This project has no tests, please fix this!'
	# cd units && ./regressiontest.sh --ctan

ctan: texdimens.zip

