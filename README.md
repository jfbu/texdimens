texdimens: a TeX and LaTeX package to convert TeX dimensions
============================================================

Distributed under the LaTeX Project Public License v1.3c, see
http://www.latex-project.org/lppl.txt

This is work in progress and this repo was created to receive
suggestions/comments/bug reports.

CTAN package
------------

Releases (see [tags](https://github.com/jfbu/texdimens/tags)) are pushed to
[CTAN](https://ctan.org) ([here](https://ctan.org/pkg/texdimens)).  Here is
how files from this repository map to those from user TeX/LaTeX installations:

| here in `texdimens/`   | in TeX/LaTeX installations |
|------------------------|----------------------------|
| texdimens.tex          | texdimens.tex              |
| texdimens.sty          | texdimens.sty              |
| README.md              | texdimens.md               |
| N/A                    | texdimens.pdf              |
| CTAN_README.md         | README.md                  |

To build the files of the [CTAN](https://ctan.org) submissions, `cd` to
`texdimens/` and execute `make ctan`.  The archive `texdimens.zip` used for
`CTAN` submissions will be found in the `CTAN/` sub-directory and the original
files will be in the `ctanbuild/` sub-directory.

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
