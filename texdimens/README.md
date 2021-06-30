texdimens
=========

## Copyright and License

Copyright (c) 2021 Jean-François B.

This file is part of the texdimens package distributed under the
LPPL 1.3c.  See file LICENSE.md.

Development: https://github.com/jfbu/texdimens

## Aim of this package

Utilities and documentation related to TeX dimensional units, usable
both with Plain (\input texdimens) and with LaTeX (\usepackage{texdimens}).

The aim of this package is to address the issue of expressing dimensions
(or dimension expressions evaluated by `\dimexpr`) in the various TeX
units, to the extent possible.

The descriptions that follow do not explain the details of the exact
internal TeX procedures of parsing dimensional input, they only describe
in a faithful manner the exact outcome of those internal procedures.
The reader is supposed to be familiar with TeX basics.

This project requires the e-TeX extensions `\dimexpr` and `\numexpr`.

Notice that this is WIP and inaccuracies may exist even relative to
descriptions of TeX handlings due to  limited time available for the project.

## TeX points and scaled points

TeX dimensions are represented internally by a signed integer which is
in absolute value at most `0x3FFFFFFF`, i.e. `1073741823`.  The
corresponding unit is called the "scaled point", i.e. `1sp` is `1/65536`
of one TeX point `1pt`, or rather `1pt` is represented internally as `65536`.

If `\foo` is a dimen register:

- `\number\foo` produces the integer `N` such as `\foo` is the same as `N sp`,

- inside `\numexpr`, `\foo` is replaced by `N`,

- `\the\foo` produces a decimal `D` (with at most five places) followed
with `pt` (catcode 12 tokens) and this output `D pt` can serve as input
in a dimen assignment to produce the same dimension as `\foo`.  One can
also use the catcode 11 characters `pt` for this.  Digits and decimal
mark must have their standard catcode 12.

When TeX encounters a dimen denotation of the type `D pt` it will
compute `N` in a way equivalent to `N = round(65536 D)` where ties are
rounded away from zero.  Only 17 decimal places of `D` are
kept as it can be shown that going beyond can not change the result.

When `\foo` has been assigned as `D pt`, `\the\foo` will produce some
`E pt` where `E` is not necessarily the same as `D`.  But it is guaranteed
that `E pt` defines the same dimension as `D pt̀`.


## Further units known to TeX on input

TeX understands on input further units: `bp`, `cm`, `mm`, `in`, `pc`,
`cc`, `nc`, `dd` and `nd`.  It also understands font-dependent units `ex` and
`em`, and PDFTeX adds the `px` dimension unit.  Japanese engines also
add specific units.

`ex`, `em`, `px` and other engine-dependent units, are all currently
excluded from consideration in this project and the rest of this
documentation is only for the `bp`, `cm`, `mm`, `in`, `pc`, `cc`, `nc`, `dd`
and `nd` units. When we say "unit" we mean one of those or the `pt` (the
`sp` is a special case and will be included or not tacitly in the "unit"
denomination depending on the case).

TeX associates to each such unit `uu` a fraction `phi` which is a conversion
factor.  It is always `>1`:

    uu     phi      reduced  real approximation  1uu in sp=   x=[65536phi]/65536  \the<1uu>
                                                 [65536phi]  (real approximation)
    --  ----------  -------  ------------------   ---------  -------------------- ----------
    bp  7227/7200   803/800   1.00375                 65781    1.0037384033203125  1.00374pt
    nd  685/642     same      1.0669781931464175      69925    1.0669708251953125  1.06697pt
    dd  1238/1157   same      1.070008643042351       70124    1.07000732421875    1.07pt   
    mm  7227/2540   same      2.8452755905511813     186467    2.8452606201171875  2.84526pt
    pc  12/1        12       12.0                    786432   12.0                12.0pt    
    nc  1370/107    same     12.80373831775701       839105   12.803726196289062  12.80373pt
    cc  14856/1157  same     12.84010371650821       841489   12.840103149414062  12.8401pt 
    cm  7227/254    same     28.45275590551181      1864679   28.452743530273438  28.45274pt
    in  7227/100    same     72.27                  4736286   72.26998901367188   72.26999pt

When TeX parses an assignment `U uu` with a decimal `U` and a unit `uu`,
among those listed above, it first handles `U` as with the `pt` unit.
This means that it computes `N = round(65536*U)`. It then multiplies
this `N` by the conversion factor `phi` and truncates towards zero the
mathematically exact result to obtain an integer `T`:
`T=trunc(N*phi)`. The assignment `U uu` is concluded by defining the
value of the dimension to be `T sp`.

Attention that although the mnemotic is `phi=1uu/1pt`, this formula
definitely does not apply with numerator and denominator interpreted as
TeX dimensions.  See the above table.  Also, the last column looks like
`round(.,5)` is applied to the previous one, but `\the\dimexpr1dd\relax`
is an exception (in the table `[x]` is the integer part, aka for
non-negative values, the `\trunc()` function).  Notice also that
`1.00375` is the exact value of the `phi` factor for the `bp` unit but
`1.00375pt>1bp` (`65782>65781`).

As `phi>1` (and is not exceedingly close to `1`), the increasing
sequence `0<=trunc(phi)<=trunc(2phi)<=...` is *strictly increasing* and
**it has jumps**: not all TeX dimensions can be obtained from an
assignment not using the `pt` unit.

The "worst" unit is the largest i.e. the `in` whose conversion factor is
`72.27`.  The simplest unit to understand is the `pc` as it corresponds
to an integer ratio `12`: only dimensions which in scaled points are
multiple of `12` are exactly representable in the `pc` unit.

This also means that some dimensions expressible in one unit may not be
available with another unit.  For example, and perhaps surprisingly,
there is no decimal `D` which would achieve `1in==Dcm`!

In particular `1in==2.54cm` is **false** in TeX, but it is true that
`100in==254cm`... It is also false that `10in==25.4cm` but it is true that
`10in==254mm`... It is false though that `1in==25.4mm`!

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
other units the maximal attainable dimensions are given in this table:

    16322.78954 bp  (\maxdimen = 1073741823 sp)
    15355.51532 nd  (\maxdimen = 1073741823 sp)
    15312.02583 dd  (1073741822 sp)
     5758.31741 mm  (1073741822 sp)
     1365.33333 pc  (1073741820 sp)
     1279.62627 nc  (1073741814 sp)
     1276.00215 cc  (1073741821 sp)
      575.83174 cm  (1073741822 sp)
      226.7054  in  (1073741768 sp)

Perhaps for these various peculiarities with dimensional units, TeX does
not provide an output facility for them similar to what `\the` achieves for
the `pt`.

## Macros of this package

All macros are expandable.  At time of writing they may not be
f-expandable, but (perhaps) in future final versions will expand fully
in two steps.  This refinement is anyhow not really important as TeX
engines now support the `\expanded` primitive.

All macros handle negative dimensions via their absolute value then
taking the opposite.

1. At time of writing only the `\texdimin<uu>` macros are implemented,
The envisioned "down" and "up" variants are not done yet.

2. For `dd`, `nc` and `in`, input equal to (or sufficiently close to)
`\maxdimen` will produce also with `\texdimin<uu>` an output `D`
representing the next "attainable" dimension above `\maxdimen` hence
using `Duu` will trigger "Dimension too large error".

3. (not yet) For input equal to (or sufficiently close to) `\maxdimen` and those
units `uu` for which `\maxdimen` is not exactly representable, i.e. all
units except `pt`, `bp` and `nd`, the output `D` of the "up" variants
`\texdimin<uu>u` if used as `Duu` in a dimension assignment or
expression will (naturally) trigger "Dimension too large" error.

4. (not yet) For some units the "down" and "up" macros may trigger "Dimension too
large" during their execution if used with an input too close to
`\maxdimen`. "Safe" variants which are guaranteed never to trigger this
error but have some extra overhead to filter out inputs too close to
`\maxdimen` will *perhaps* be provided. But see 2. and 3. regarding the
usability of the output anyhow.

`\texdiminpt{<dim. expr.>}`

> Does `\the\dimexpr <dim. expr.> \relax` then removes the `pt`.

`\texdiminbp{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> bp` represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> `\maxdimen` on input produces `16322.78954` and indeed is realized as `16322.78954bp`.

`\texdiminbpd{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> bp` represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

`\texdiminbpu{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> bp` represents the dimension exactly if possible. If not possible it
> will be larger by `1sp` from the original dimension.

`\texdiminnd{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> nd` represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> `\maxdimen` on input produces `15355.51532` and indeed is realized as `15355.51532nd`.

`\texdiminndd{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> nd` represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

`\texdiminndu{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> nd` represents the dimension exactly if possible. If not possible it
> will be larger by `1sp` from the original dimension.

`\texdimindd{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> dd` represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> Warning: the output for `\maxdimen` is `15312.02585` but `15312.02585dd`
> will trigger "Dimension too large" error.
> `\maxdimen-1sp` is atteignable via `15312.02583dd`.

`\texdiminddd{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> dd` represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

`\texdiminddu{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> dd` represents the dimension exactly if possible. If not possible it
> will be larger by `1sp` from the original dimension.

`\texdiminmm{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> mm` represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> `\maxdimen` as input produces on output `5758.31741` and indeed the
> maximal attainable dimension is `5758.31741mm` (`1073741822sp`).

`\texdiminmmd{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> mm` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdiminmmu{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> mm` represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.

`\texdiminpc{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> pc` represents the dimension exactly if possible. If not possible it
> will be the closest representable one (in case of tie, the approximant
> from above is chosen).

> `\maxdimen` as input produces on output `1365.33333` and indeed the
> maximal attainable dimension is `1365.33333pc` (`1073741820sp`).

`\texdiminpcd{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> pc` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdiminpcu{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> pc` represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.

`\texdiminnc{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> nc` represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> Warning: the output for `\maxdimen` is `1279.62628` but `1279.62628nc`
> will trigger "Dimension too large" error.
> `\maxdimen-9sp` is attainable via `1279.62627nc`.

`\texdiminncd{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> nc` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdiminncu{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> nc` represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.

`\texdimincc{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> cc` represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advacce which one (and it is not known if the other choice
> would have been closer).

> `\maxdimen` as input produces on output `1276.00215` and indeed the
> maximal attainable dimension is `1276.00215cc` (`1073741821sp`).

`\texdiminccd{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> cc` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdiminccu{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> cc` represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.

`\texdimincm{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> cm` represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> `\maxdimen` as input produces on output `575.83174` and indeed the
> maximal attainable dimension is `575.83174cm` (`1073741822sp`).

`\texdimincmd{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> cm` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdimincmu{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> cm` represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.

`\texdiminin{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> in` represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> Warning: the output for `\maxdimen` is `226.70541` but `226.70541in`
> will trigger "Dimension too large" error.
> `\maxdimen-55sp` is maximal attainable dimension (via `226.7054in`).

`\texdiminind{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> in` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdimininu{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> in` represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.


## TODO

Implement the "up" and "down" variants.

Provide a macro `\texdimnearest{in,cm}{<dim.expr.>}` which provides the
nearest dimension simultaneously representable both in `in` and in `cm`?
According to a reference on the web by an anonymous contributor the
available positive dimensions in scaled points have the shape
`floor(3613.5*k) sp` for some integer `k`. So we basically may have a
delta up to about `1800sp` which is about `0.0275pt` and is still small
(less than one hundredth of a millimeter), so perhaps such a utility for
"safe dimensions" may be useful. Simpler however and more efficient
would be for people to finally adopt the French revolution Système
Métrique (rather than setting up giant financial paradises).

<!--
%! Local variables:
%! sentence-end-double-space: t
%! fill-column: 72
%! End:
-->
