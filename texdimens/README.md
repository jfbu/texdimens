% texdimens 1.1
% Jean-François B.
% 2021/11/17

## Copyright and License

Copyright (c) 2021 Jean-François B.

The texdimens [CTAN package](https://ctan.org/pkg/texdimens) is
distributed under the [LPPL 1.3c](https://ctan.org/license/lppl1.3c).

## Usage

Utilities and documentation related to TeX dimensional units, usable:

- with Plain TeX: `\input texdimens`

- with LaTeX: `\usepackage{texdimens}`

For reporting issues, use the
[package repository](https://github.com/jfbu/texdimens).

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

## Quick review of basics: TeX points and scaled points

TeX dimensions are represented internally by a signed integer which is
in absolute value at most `0x3FFFFFFF`, i.e. `1073741823`.  The
corresponding unit is called the "scaled point", i.e. `1sp` is `1/65536`
of one TeX point `1pt`, or rather `1pt` is represented internally as `65536`.

If `\foo` is a dimen register:

- `\number\foo` produces the integer `N` such as `\foo` is the same as `Nsp`,

- inside `\numexpr`, `\foo` is replaced by `N`,

- `\the\foo` produces a decimal `D` (with at most five places) followed
  with `pt` (catcode 12 tokens) and this output `Dpt` can serve as input
  in a dimen assignment to produce the same dimension as `\foo`.  One can
  also use the catcode 11 characters `pt` for this.  Digits and decimal
  mark must have their standard catcode 12.

When TeX encounters a dimen denotation of the type `Dpt` it will
compute `N` in a way equivalent to `N = round(65536 D)` where ties are
rounded away from zero.  Only 17 decimal places of `D` are
kept as it can be shown that going beyond can not change the result.

When `\foo` has been assigned as `Dpt`, `\the\foo` will produce some
`Ept` where `E` is not necessarily the same as `D`.  But it is guaranteed
that `Ept` defines the same dimension as `Dpt`.

## Further units known to TeX on input

TeX understands on input further units: `bp`, `cm`, `mm`, `in`, `pc`,
`cc`, `nc`, `dd` and `nd`.  It also understands font-dependent units
`ex` and `em`, and PDFTeX adds the `px` dimension unit.  Japanese
engines also add specific units.

The `ex`, `em`, and `px` units are handled somewhat differently by
(pdf)TeX than `bp`, `cm`, `mm`, `in`, `pc`, `cc`, `nc`, `dd` and `nd`
units. For the former (let's use the generic notation `uu`), the exact
same dimensions are obtained from an input `D uu` where `D` is some
decimal or from `D <dimen>` where `<dimen>` stands for some dimension
register which records `1uu` or `\dimexpr1uu\relax`. In contrast, among
the latter, i.e. the core TeX units, this is false except for the `pc`
unit.

TeX associates (explicitly for the core units, implicitly for the units
corresponding to internal dimensions) to each unit `uu` a fraction `phi`
which is a conversion factor.  For the internal dimensions `ex`, `em`,
`px` or in the case of multiplying a dimension by a decimal, this `phi`
is morally `f/65536` where `f` is the integer such that `1 uu=f sp`.
For core units however, the hard-coded ratio `n/d` never has a
denominator `d` which is a power of `2`, except for the `pc` whose
associated ratio factor is `12/1` (and arguably for the `sp` for which
morally `phi` is `1/65536` but we keep it separate from the general
discussion; as well as `pt` with its unit conversion factor).

Here is a table with the hard-coded conversion factors:

    uu     phi      reduced  real approximation  1uu in sp=  \the<1uu> 
                             (Python output)     [65536phi]            
    --  ----------  -------  ------------------   ---------  ----------
    bp  7227/7200   803/800   1.00375                 65781   1.00374pt
    nd  685/642     same      1.0669781931464175      69925   1.06697pt
    dd  1238/1157   same      1.070008643042351       70124   1.07pt   
    mm  7227/2540   same      2.8452755905511813     186467   2.84526pt
    pc  12/1        12       12.0                    786432  12.0pt    
    nc  1370/107    same     12.80373831775701       839105  12.80373pt
    cc  14856/1157  same     12.84010371650821       841489  12.8401pt 
    cm  7227/254    same     28.45275590551181      1864679  28.45274pt
    in  7227/100    same     72.27                  4736286  72.26999pt

The values of `1uu` in the `sp` and `pt` units are irrelevant and even
misleading regarding the TeX parsing of `D uu` input.  Notice for
example that `\the\dimexpr1bp\relax` gives `1.00374pt` but the actual
conversion factor is `1.00375` (and
`1.00375pt=65782sp>1bp`...). Similarly `\the\dimexpr1in\relax` outputs
`72.26999pt` and is represented internally as `4736286sp` but the actual
conversion factor is `72.27=7227/100`, and
`72.27pt=4736287sp>1in`... And for the other units except the `pc`, the
conversion factors are not decimal numbers, so even less likely to match
`\the<1uu>` as listed in the last column. Their denominators are not
powers of `2` so they don't match exactly either `(1uu in sp)/65536` but
are only close.

When TeX parses an assignment `U uu` with a decimal `U` and a unit `uu`,
be it a core unit, or a unit corresponding to an internal dimension,
it first handles `U` as with the `pt` unit.
This means that it computes `N = round(65536*U)`. It then multiplies
this `N` by the conversion factor `phi` and truncates towards zero the
mathematically exact result to obtain an integer `T`:
`T=trunc(N*phi)`. The assignment `Uuu` is concluded by defining the
value of the dimension to be `Tsp`.

Regarding the core units, we always have `phi>1`.
The increasing
sequence `0<=trunc(phi)<=trunc(2phi)<=...` is thus *strictly increasing*
and, as `phi` is never astronomically close to `1`, 
**it always has jumps**: not all TeX dimensions can be obtained from an
assignment using a core unit distinct from the `pt` (and `sp` of course,
but we already said it was kept out of the discussion here).

On the other hand when `phi<1`, then the sequence `trunc(N phi)` is not
strictly increasing, already because `trunc(phi)=0` and besides here
`phi=f/65536`, so the `65536` integers `0..65535` are mapped to `f`
integers `0..(f-1)` inducing non one-to-oneness. But
all integers in the `0..(2**30-1)` range will be attained for some input,
so there is surjectivity.

The "worst" unit is the largest i.e. the `in` whose conversion factor is
`72.27`.  The simplest unit to understand is the `pc` as it corresponds
to an integer ratio `12`: only dimensions which in scaled points are
multiple of `12` are exactly representable in the `pc` unit.

This also means that some dimensions expressible in one unit may not be
available with another unit.  For example, and perhaps surprisingly,
there is no decimal `D` which would achieve `1in==Dcm`: the "step"
between attainable dimensions is `72--73sp` for the `in` and `28--29sp`
for the `cm`, and as `1in` differs internally from `2.54cm` by only
`12sp` it is impossible to adjust
either the `in` side or the `cm` side to obtain equality.

In particular `1in==2.54cm` is **false** in TeX, but it is true that
`100in==254cm`... (it is already true that `50in==127cm`).  It is also
false that `10in==25.4cm` but it is true that `10in==254mm`... It is
false though that `1in==25.4mm`!

    >>> (\dimexpr1in, \dimexpr2.54cm);
    @_1     4736286, 4736274
    >>> (\dimexpr10in, \dimexpr25.4cm);
    @_2     47362867, 47362855
    >>> (\dimexpr100in, \dimexpr254cm);
    @_3     473628672, 473628672
    
    >>> (\dimexpr1in, \dimexpr25.4mm);
    @_4     4736286, 4736285
    >>> (\dimexpr10in, \dimexpr254mm);
    @_5     47362867, 47362867

`\maxdimen` can be expressed only with `pt`, `bp`, and `nd`.  For the
other core units the maximal attainable dimensions in `sp` unit are given in
the middle column of the next table.

    maximal allowed      the corresponding      minimal TeX dimen denotation
    (with 5 places)   maximal attainable dim.   causing "Dimension too large"
    ---------------  -------------------------  --------------------------
    16383.99999pt    1073741823sp (=\maxdimen)  16383.99999237060546875pt
    16322.78954bp    1073741823sp (=\maxdimen)  16322.78954315185546875bp
    15355.51532nd    1073741823sp (=\maxdimen)  15355.51532745361328125nd
    15312.02584dd    1073741822sp               15312.02584075927734375dd
     5758.31742mm    1073741822sp                5758.31742095947265625mm
     1365.33333pc    1073741820sp                1365.33333587646484375pc
     1279.62627nc    1073741814sp                1279.62627410888671875nc
     1276.00215cc    1073741821sp                1276.00215911865234375cc
      575.83174cm    1073741822sp                 575.83174896240234375cm
      226.70540in    1073741768sp                 226.70540618896484375in

Perhaps for these various peculiarities with dimensional units, TeX does
not provide an output facility for them similar to what `\the` achieves for
the `pt`.

## Macros of this package (full list)

This project requires the `\dimexpr`, `\numexpr` e-TeX extensions.  It
also requires the `\expanded` primitive (available in all engines since
TeXLive 2019).

The macros provided by the package are all expandable, even
f-expandable. They parse their arguments via `\dimexpr` so can be nested
(with appropriate units added, as the outputs always are bare decimal
numbers).

The notation `<dim. expr.>` in the macro descriptions refers to a
*dimensional expression* as accepted by `\dimexpr`.  The syntax has some
peculiarities: among them the fact that `-(...)` (for example `-(3pt)`)
is illegal, one must use alternatives such as `0pt-(...)` or a
sub-expression `-\dimexpr...\relax` for example.

Negative dimensions behave as if replaced by their absolute value, then
at last step the sign (if result is not zero) is applied (so "down" means
"towards zero", and "up" means "away from zero").

Remarks about "Dimension too large" issues:

1. For input `X` equal to `\maxdimen` (or differing by a few `sp`'s) and
   those units `uu` for which `\maxdimen` is not exactly representable
   (i.e. all core units except `pt`, `bp` and `nd`), the output `D` of
   the "up" macros `\texdimen<uu>up{X}`, if used as `Duu` in a dimension
   assignment or expression, will (as is logical) trigger a "Dimension
   too large" error.
2. For `dd`, `nc` and `in`, it turns out that `\texdimen<uu>{X}` chooses
   the "up" approximant for `X` equal to or very near `\maxdimen` (check
   the respective macro documentations),
   i.e. the output `D` is such that `Duu` is the first virtually
   attainable dimension beyond `\maxdimen`. Hence `Duu` will trigger on
   use a "Dimension too large error".  With the other units for which
   `\maxdimen` is not attainable exactly, `\texdimen<uu>{\maxdimen}`
   output is by luck the "down" approximant.
3. Similarly the macro `\texdimenwithunit{D1pt}{D2pt}` covers the entire
   dimension range, but its output `F` for `D1pt` equal to or very close
   to `\maxdimen` may be such that `F<D2pt>` represents a dimension
   beyond `\maxdimen`, if the latter is not exactly representable.
   Hence `F<D2pt>` would trigger "Dimension too large" on use.  This can
   only happen if `D2pt>1pt` and (roughly) `D1pt>\maxdimen-D2sp`. As
   `D2sp` is less than `0.25pt`, this is not likely to occur in real
   life practice except if deliberately targeting `\maxdimen`. For
   `D2pt<1pt`, all dimensions `D1pt` are exactly representable, in
   particular `\maxdimen`, and the output `F` will always be such that
   TeX parses `F<D2pt>` into exactly the same dimension as `D1pt`.

### `\texdimenpt{<dim. expr.>}`

> Does `\the\dimexpr <dim. expr.> \relax` then removes the `pt`.

### `\texdimenbp{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dbp`
> represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> `\maxdimen` on input produces `16322.78954` and indeed is realized as
> `16322.78954bp`.

### `\texdimenbpdown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dbp`
> represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

### `\texdimenbpup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dbp`
> represents the dimension exactly if possible. If not possible it
> will be larger by `1sp` from the original dimension.

### `\texdimennd{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dnd`
> represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> `\maxdimen` on input produces `15355.51532` and indeed is realized as
> `15355.51532nd`.

### `\texdimennddown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dnd`
> represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

### `\texdimenndup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dnd`
> represents the dimension exactly if possible. If not possible it
> will be larger by `1sp` from the original dimension.

### `\texdimendd{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Ddd`
> represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> Warning: the output for `\maxdimen` is `15312.02585` but `15312.02585dd`
> will trigger on use "Dimension too large" error.
> `\maxdimen-1sp` is the maximal input for which the output remains
> less than `\maxdimen` (max attainable dimension: `\maxdimen-1sp`).

### `\texdimendddown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Ddd`
> represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

### `\texdimenddup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Ddd`
> represents the dimension exactly if possible. If not possible it
> will be larger by `1sp` from the original dimension.
>
> If input is `\maxdimen`, then `Ddd` virtually represents
> `\maxdimen+1sp` and will trigger on use "Dimension too large".

### `\texdimenmm{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dmm`
> represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> `\maxdimen` as input produces on output `5758.31741` and indeed the
> maximal attainable dimension is `5758.31741mm` (`\maxdimen-1sp`).

### `\texdimenmmdown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dmm`
> represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

### `\texdimenmmup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dmm`
> represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.
>
> If input is `\maxdimen`, then `Dmm` virtually represents
> `\maxdimen+2sp` and will trigger on use "Dimension too large".

### `\texdimenpc{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dpc`
> represents the dimension exactly if possible. If not possible it
> will be the closest representable one (in case of tie, the approximant
> from above is chosen).

> `\maxdimen` as input produces on output `1365.33333` and indeed the
> maximal attainable dimension is `1365.33333pc` (`\maxdimen-3sp`).

### `\texdimenpcdown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dpc`
> represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

### `\texdimenpcup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dpc`
> represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.
>
> If input is `>\maxdimen-3sp`, then `Dpc` virtually represents
> `\maxdimen+9sp` and will trigger on use "Dimension too large".

### `\texdimennc{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dnc`
> represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> Warning: the output for `\maxdimen-1sp` is `1279.62628` but `1279.62628nc`
> will trigger on use "Dimension too large" error.
> `\maxdimen-2sp` is the maximal input for which the output remains
> less than `\maxdimen` (max attainable dimension: `\maxdimen-9sp`).

### `\texdimenncdown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dnc`
> represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

### `\texdimenncup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dnc`
> represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.
>
> If input is `>\maxdimen-9sp`, then `Dnc` virtually represents
> `\maxdimen+4sp` and will trigger on use "Dimension too large".

### `\texdimencc{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dcc`
> represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> `\maxdimen` as input produces on output `1276.00215` and indeed the
> maximal attainable dimension is `1276.00215cc` (`\maxdimen-2sp`).

### `\texdimenccdown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dcc`
> represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

### `\texdimenccup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dcc`
> represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.
>
> If input is `>\maxdimen-2sp`, then `Dcc` virtually represents
> `\maxdimen+11sp` and will trigger on use "Dimension too large".

### `\texdimencm{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dcm`
> represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> `\maxdimen` as input produces on output `575.83174` and indeed the
> maximal attainable dimension is `575.83174cm` (`\maxdimen-1sp`).

### `\texdimencmdown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dcm`
> represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

### `\texdimencmup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dcm`
> represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.
>
> If input is `\maxdimen`, then `Dcm` virtually represents
> `\maxdimen+28sp` and will trigger on use "Dimension too large".

### `\texdimenin{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Din`
> represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> Warning: the output for `\maxdimen-18sp` is `226.70541` but `226.70541in`
> will trigger on  use "Dimension too large" error.
> `\maxdimen-19sp` is the maximal input for which the output remains
> less than `\maxdimen` (max attainable dimension: `\maxdimen-55sp`).

### `\texdimenindown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Din`
> represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

### `\texdimeninup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Din`
> represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.
>
> If input is `>\maxdimen-55sp`, then `Din` virtually represents
> `\maxdimen+17sp` and will trigger on use "Dimension too large".

### `\texdimenbothcmin{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that
> `Din` is the largest dimension not exceeding the original one (in
> absolute value) and exactly representable both in the `in` and `cm`
> units.

### `\texdimenbothincm{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that
> `Dcm` is the largest dimension not exceeding the original one (in
> absolute value) and exactly representable both in the `in` and `cm`
> units. Thus both expressions `\texdimenbothcmin{<dim. expr.>}in` and
> `\texdimenbothincm{<dim. expr.>}cm` represent the same dimension.

### `\texdimenbothcminpt{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that
> `Dpt` is the largest dimension not exceeding the original one (in
> absolute value) and exactly representable both in the `in` and `cm`
> units.  It thus represents the same dimension as the one determined by
> `\texdimenbothcmin` and `\texdimenbothincm`.

### `\texdimenbothincmpt{<dim. expr.>}`

> Alias for `\texdimenbothcminpt`.

### `\texdimenbothcminsp{<dim. expr.>}`

> Produces an integer (explicit digit tokens) `N` such that `Nsp` is the
> largest dimension not exceeding the original one in absolute value and
> exactly representable both in the `in` and `cm` units.

### `\texdimenbothincmsp{<dim. expr.>}`

> Alias for `\texdimenbothcminsp`.

### `\texdimenbothbpmm{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that
> `Dmm` is the largest dimension smaller (in absolute value) than the
> original one and exactly representable both in the `bp` and `mm`
> units.

### `\texdimenbothmmbp{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that
> `Dbp` is the largest dimension smaller (in absolute value) than the
> original one and exactly representable both in the `bp` and `mm`
> units.  Thus `\texdimenbothmmbp{<dim. expr.>}bp` is the same
> dimension as `\texdimenbothbpmm{<dim. expr.>}mm`.

### `\texdimenbothbpmmpt{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that
> `Dpt` is the largest dimension not exceeding the original one and
> exactly representable both in the `bp` and `mm` units.

### `\texdimenbothmmbppt{<dim. expr.>}`

> Alias for `\texdimenbothbpmmpt`.

### `\texdimenbothbpmmsp{<dim. expr.>}`

> Produces an integer (explicit digit tokens) `N` such that `Nsp`
> is the largest dimension not exceeding the original one and
> exactly representable both in the `bp` and `mm` units.

### `\texdimenbothmmbpsp{<dim. expr.>}`

> Alias for `\texdimenbothbpmmsp`.

### `\texdimenwithunit{<dim. expr. 1>}{<dim expr. 2>}`

> Produces a decimal `D` such that `D\dimexpr <dim expr. 2>\relax` is
> considered by TeX the same as `<dim. expr. 1>` if at all possible.  If
> the (assumed non zero) second argument `<dim2>` is at most `1pt` (in
> absolute value), then this is always possible.  If the second argument
> `<dim2>` is `>1pt` then this is not always possible and the output `D`
> will ensure for `D<dim2>` to be a closest match to the first argument
> `dim1` either from above or below, but one does not know if the other
> direction would have given a better or worst match.
>
> `\texdimenwithunit{<dim>}{1bp}` and `\texdimenbp{<dim>}` are not
> the same: The former produces a decimal `D` such that `D\dimexpr 1bp\relax`
> is represented internally as is `<dim>` if at all possible,
> whereas the latter produces a decimal `D` such that `D bp` is the one
> aiming at being the same as `<dim>`. Using `D\dimexpr 1bp\relax` implies
> a conversion factor equal to `65781/65536`, whereas `D bp` involves
> the `803/800` conversion factor.
>
> `\texdimenwithunit{D1pt}{D2pt}` output is close to the mathematical
> ratio `D1/D2`. But notwithstanding the various unavoidable "errors"
> arising from conversion of decimal inputs to binary internals, and
> from the latter to the former, the output `R` will tend to be
> on average slightly larger (in its last decimal) than mathematical
> `D1/D2`. The root cause being that the specification for `R` is that
> `R<D2pt>` must be exactly `<D1pt>` after TeX parsing, if at all
> possible; and it turns out this is always possible for `D2pt<1pt`. The
> final step in the TeX parsing of a multiplication of a dimension by a
> scalar is a *truncation* to an integer multiple of the `sp=1/65536pt`
> unit, not a rounding. So `R` is basically (i.e. before conversion to a
> decimal) `ceil(D1/D2,16)`, or to be more precise it is obtained as
> `ceil(N1/N2,16)` with `D1pt->N1sp`, `D2pt->N2sp` and the second
> argument of `ceil` means that `16` binary places are used. This
> formula is the one used for `D2pt<1pt`, for `D2pt>1pt` the mathematics
> is different, but the implication that `R` has a (less significant)
> bias to be "shifted upwards" (in its last decimal place) compared to
> the (rounded) value `D1/D2` or rather `N1/N2` still stands.

## Change log

### [1.1 (2021/11/17)](https://github.com/jfbu/texdimens/compare/1.0...HEAD#files_bucket)

- internal refactorings across the entire code base aiming at (small)
  efficiency gains from optimized TeX token manipulations
- in particular, the algorithm for `\texdimenwithunit{<dim1>}{<dim2>}`
  in the "`dim2<1pt`" branch got modified (output unchanged)
- all macros now f-expandable (this was already the case at `1.0` except
  for `\texdimenwithunit` with arguments of opposite signs, the
  second one not exceeding `1pt` in absolute value)
- the `\expanded` primitive is required (present in all engines since
  TeXLive 2019)
- the usual batch of documentation additions or fix-ups, also in
  code comments (fix in particular issues #21, #22)
- addition of this Change log to the pdf documentation
- addition of the highlighted commented source code to the pdf documentation

### [1.0 (2021/11/10)](https://github.com/jfbu/texdimens/compare/0.99d...1.0#files_bucket)

- new: `\texdimenbothbpmm` and relatives (feature request #10)
- breaking: `\texdimenwithunit` output for second argument `<1pt` still
  obeys specs but is closer to mathematical ratio (feature request #16)
- enhanced: all `up/down` macros (i.e. also for the `dd`, `nc`, `in`
  units) accept the full range of dimensions (feature request #18)
- enhanced: `\texdimenwithunit`'s second argument is now allowed
  to be negative (feature request #13)

### [0.99a-d (2021/11/04)](https://github.com/jfbu/texdimens/compare/0.99...0.99d#files_bucket)

- documentation in TeX/LaTeX installations available in pdf format
- the usual batch of documentation additions or fix-ups
- let the CTAN `README.md` be much shortened, and provide `texdimens.md`
  as the one matching the repo `README.md`
- fix bugs of `\texdimenwithunit{<dim1>}{<dime2>}` for `dim1=0pt` or
  `dim2=1pt` (#3, #4, #6, #8)

### [0.99 (2021/11/02)](https://github.com/jfbu/texdimens/compare/0.9...0.99#files_bucket)

- new: `\texdimenwithunit{<dim1>}{<dim2>}` (feature request #2)

### [0.9 (2021/07/21)](https://github.com/jfbu/texdimens/compare/0.9delta...0.9#files_bucket)

- new: `\texdimenbothincm` and relatives
- breaking: use `\texdimen` prefix for all macros

### [0.9delta (2021/07/15)](https://github.com/jfbu/texdimens/compare/0.9gamma...0.9delta#files_bucket)

- internal refactorings

### [0.9gamma (2021/07/14)](https://github.com/jfbu/texdimens/compare/0.9beta...0.9gamma#files_bucket)

- new: `\texdiminbpdown` (now `\texdimenbpdown`), `\texdiminbpup`
  (now `\texdimenbpup`) and similar named macros associated with
  the other units

### [0.9beta (2021/06/30)](https://github.com/jfbu/texdimens/compare/54f4eb13...0.9beta#files_bucket)

- initial release: provides `\texdiminbp` (now `\texdimenbp`) and
  similar named macros for the units `nd`, `dd`, `mm`, `pc`, `nc`, `cc`,
  `cm`, `in`


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
