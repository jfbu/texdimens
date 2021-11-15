texdimens: a TeX and LaTeX package to convert TeX dimensions
============================================================

This is the development repository for the
[CTAN package texdimens](https://ctan.org/pkg/texdimens), which is distributed
under the LaTeX Project Public License v1.3c, see
http://www.latex-project.org/lppl.txt

CTAN package
------------

Releases (see the [tags](https://github.com/jfbu/texdimens/tags)) are pushed
to [CTAN](https://ctan.org).  Here is how files from this repository map to
those from the CTAN submission (hence also from user TeX/LaTeX installations):

| here in `texdimens/`   | in TeX/LaTeX installations |
|------------------------|----------------------------|
| texdimens.tex          | texdimens.tex              |
| texdimens.sty          | texdimens.sty              |
| README.md              | texdimens.md               |
| N/A                    | texdimens.pdf              |
| CTAN_README.md         | README.md                  |

- to build `texdimens.pdf` from its source (here `texdimens/README.md`), `cd`
  to `texdimens/` and execute `make texdimens.pdf`.  Requires `pandoc`,
  `pygmentize`, and a TeX/LaTeX installation.

- to build all the files entering into the [CTAN](https://ctan.org)
  package, `cd` to `texdimens/` and execute there `make ctan`.  This
  produces `texdimens.zip` to be found in the `CTAN/` sub-directory, the files
  included into the archive being in the `ctanbuild/` sub-directory.

Opening a new issue
-------------------

This is what this repo is for, so don't hesitate doing it.

*Please ping me from the issue creation message.*

Indeed, although once an issue is created, or a PR, I will be notified of any
new comment, or push, it seems there is no way to let GitHub notify me of *new
issues*, because of my global preferences on repos I watch.  Basically, for
getting notified, I would have to activate the functionality for *all repos I
watch*, there is no way to activate it only for the *repos I own*.  Repos I
watch still notify me when I am mentioned or when a comment is made on an
issue I contributed to.  I currently don't want my email account to be flooded
with all the activity on various repos I do watch, and again, there seems to
be no way to configure GitHub to send notifications on more events *only
for repos I own*.

Last investigated on 2021/11/06.  If I am missing something obvious, please
tell me.

<!--
Local variables:
sentence-end-double-space:t
End:
-->
