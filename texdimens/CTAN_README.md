texdimens
=========

## Copyright and License

Copyright (c) 2021 Jean-François B.

This file is part of the texdimens package distributed under the
LPPL 1.3c.  See file LICENSE.md.

Repository: https://github.com/jfbu/texdimens

Release: `0.99a 2021/11/04`

## Usage

Utilities and documentation related to TeX dimensional units, usable:

- with Plain TeX: `\input texdimens`

- with LaTeX: `\usepackage{texdimens}`

## Aim of this package

The aim of this package is to provide facilities to express dimensions
(or dimension expressions evaluated by `\dimexpr`) using the various
available TeX units, to the extent possible.

## Macros of this package (summary)

This package provides expandable macros:

- `\texdimenpt`,
- `\texdimenUU`, `\texdimenUUup` and
  `\texdimenUUdown` with `UU` standing for one of `bp`, `cm`, `mm`, `in`,
  `pc`, `cc`, `nc`, `dd` and `nd`,
- `\texdimenbothincm` (and relatives, see full documentation),
- `\texdimenwithunit`.

For example `\texdimenbp` takes on input some dimension or dimension
expression and produces on output a decimal `D` such that `D bp` is
guaranteed to be the same dimension as the input, if that one admits any
representation as `E bp`; else it will be either the closest match from
above or from below (for this unit the error is at most `1sp`).

The variants `\texdimenbpup` and `\texdimenbpdown` allow to choose the
direction of approximation.

`\texdimenwithunit{<dimen1>}{<dimen2>}` produces a decimal `D` such that
`D \dimexpr dimen2\relax` is parsed by TeX into the same dimension as
`dimen1` if this is at all possible.  If `dimen2<1pt` all TeX dimensions
`dimen1` are attainable.  If `dimen2>1pt` not all `dimen1` are
attainable.  If not attainable, the decimal `D` will ensure a closest
match from below or from above but one does not know if the
approximation from the other direction is better or worst.

In a sense, this macro divides `<dimen1>` by `<dimen2>` but please refer
to the full documentation (`texdimens.md`, `texdimens.pdf`) for relevant
information on how TeX handles dimensions.

## Acknowledgements

Thanks to Denis Bitouzé for raising an
[issue](https://github.com/latex3/latex3/issues/953)
on the LaTeX3 tracker which became the initial stimulus for this package.

Thanks to Ruixi Zhang for reviving the above linked-to thread
and opening up here [issue #2](https://github.com/jfbu/texdimens/issues/2)
asking to add handling of the `ex`,`em`, and `px` cases. This was done
at release `0.99` via the addition of `\texdimenwithunit`.

<!--
%! Local variables:
%! sentence-end-double-space: t
%! fill-column: 72
%! End:
-->
