texdimens
=========

## Copyright and License

Copyright (c) 2021 Jean-François B.

This file is part of the texdimens package distributed (see file
LICENSE.md) under the [LPPL 1.3c](https://ctan.org/license/lppl1.3c).

Release: [1.1 2021/11/17](https://github.com/jfbu/texdimens/compare/1.0...HEAD#files_bucket) (to be released)

## Usage

Utilities and documentation related to TeX dimensional units, usable:

- with Plain TeX: `\input texdimens`

- with LaTeX: `\usepackage{texdimens}`

Development and issue tracking: https://github.com/jfbu/texdimens

## Aim of this package

The aim of this package is to provide facilities to express dimensions
(or dimension expressions evaluated by `\dimexpr`) using the various
available TeX units, to the extent possible.

## Macros of this package (summary)

This package provides expandable macros:

- `\texdimenUU` with `UU` standing for one of `pt`, `bp`, `cm`, `mm`,
  `in`, `pc`, `cc`, `nc`, `dd` and `nd`,
- `\texdimenUUup` and `\texdimenUUdown` with `UU` as above except `pt`,
- `\texdimenbothincm` and relatives,
- `\texdimenbothbpmm` and relatives,
- `\texdimenwithunit`.

`\texdimenbp` takes on input some dimension or dimension expression and
produces on output a decimal `D` such that `D bp` is guaranteed to be
the same dimension as the input, *if* it admits any representation as `E bp`;
else it will be either the closest match from above or from
below. For this unit, as well as for `nd` and `dd` the difference is at
most `1sp`. For other units (not `pt` of course) the distance will
usually be larger than `1sp` and one does not know if the approximant
from the other direction would have been better or worst.

The variants `\texdimenbpup` and `\texdimenbpdown` expand slightly less
fast than `\texdimenbp` but they allow to choose the direction of
approximation (in absolute value).

The macros associated to the other units have
the same descriptions.

`\texdimenbothincm`, respectively `\texdimenbothbpmm`, find the largest
(in absolute value) dimension not exceeding the input and exactly
representable both with the `in` and `cm` units, respectively exactly
representable both with the `bp` and `mm` units.

`\texdimenwithunit{<dimen1>}{<dimen2>}` produces a decimal `D` such that
`D \dimexpr dimen2\relax` is parsed by TeX into the same dimension as
`dimen1` if this is at all possible.  If `dimen2<1pt` all TeX dimensions
`dimen1` are attainable.  If `dimen2>1pt` not all `dimen1` are
attainable.  If not attainable, the decimal `D` will ensure a closest
match from below or from above but one does not know if the
approximation from the other direction is better or worst.

In a sense, this macro divides `<dimen1>` by `<dimen2>`, see additional
details in the complete macro description.

## Acknowledgements

Thanks to Denis Bitouzé for raising an
[issue](https://github.com/latex3/latex3/issues/953)
on the LaTeX3 tracker which became the initial stimulus for this package.

Thanks to Ruixi Zhang for reviving the above linked-to thread and
opening up on the package issue tracker the
[issue #2](https://github.com/jfbu/texdimens/issues/2) asking to add
handling of the `ex` and `em` cases. This was done at release `0.99` via
the addition of `\texdimenwithunit`.

Renewed thanks to Ruixi Zhang for analyzing at
[issue #10](https://github.com/jfbu/texdimens/issues/10) what is at
stake into finding dimensions exactly representable both in the `bp` and
`mm` units. Macros `\texdimenbothbpmm` and `\texdimenbothmmbp` now
address this (release `1.0`).

<!--
%! Local variables:
%! sentence-end-double-space: t
%! fill-column: 72
%! End:
-->
