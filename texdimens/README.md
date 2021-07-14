texdimens
=========

## Copyright and License

Copyright (c) 2021 Jean-François B.

This file is part of the texdimens package distributed under the
LPPL 1.3c.  See file LICENSE.md.

Development: https://github.com/jfbu/texdimens

## Aim of this package

Utilities and documentation related to TeX dimensional units, usable
both with Plain (`\input texdimens`) and with LaTeX (`\usepackage{texdimens}`).

The aim of this package is to address the issue of expressing dimensions
(or dimension expressions evaluated by `\dimexpr`) in the various TeX
units, to the extent possible.

The descriptions that follow do not explain the details of the exact
internal TeX procedures of parsing dimensional input, they only describe
in a faithful manner the exact outcome of those internal procedures.
The reader is supposed to be familiar with TeX basics.

This project requires the e-TeX extensions `\dimexpr` and `\numexpr`.
The notation `<dim. expr.>` in the macro descriptions refers to a
*dimensional expression* as accepted by `\dimexpr`.  The syntax has some
peculiarities: among them the fact that `-(...)` (for example `-(3pt)`)
is illegal, one must use alternatives such as `0pt-(...)` or a
sub-expression `-\dimexpr...\relax` for example.

Notice that this is WIP and inaccuracies may exist even relative to
descriptions of TeX handlings due to limited time available for the
project.

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
                             (Python output)     [65536phi]  (real approximation)
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
there is no decimal `D` which would achieve `1in==Dcm`: the "step"
between attainable dimensions is `72--73sp` for the `in` and `28--29sp`
for the `cm`, and as `1in` differs internally from `2.54cm` by only
`12sp` (see below the `xintsession` verbatim) it is impossible to adjust
either the `in` side or the `cm` side to obtain equality.  See in the
[TODO] section the closest dimension attainable both via `in` and via
`cm`.

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
other units the maximal attainable dimensions in `sp` unit are given in
the middle column of the next table.

    maximal allowed      the corresponding       minimal TeX dimen denotation
    (with 5 places)   maximal attainable dim.    causing "Dimension too large"
    ---------------  --------------------------  --------------------------
    16383.99999 pt   1073741823 sp (=\maxdimen)  16383.99999237060546875 pt
    16322.78954 bp   1073741823 sp (=\maxdimen)  16322.78954315185546875 bp
    15355.51532 nd   1073741823 sp (=\maxdimen)  15355.51532745361328125 nd
    15312.02584 dd   1073741822 sp               15312.02584075927734375 dd
     5758.31742 mm   1073741822 sp                5758.31742095947265625 mm
     1365.33333 pc   1073741820 sp                1365.33333587646484375 pc
     1279.62627 nc   1073741814 sp                1279.62627410888671875 nc
     1276.00215 cc   1073741821 sp                1276.00215911865234375 cc
      575.83174 cm   1073741822 sp                 575.83174896240234375 cm
      226.70540 in   1073741768 sp                 226.70540618896484375 in

Perhaps for these various peculiarities with dimensional units, TeX does
not provide an output facility for them similar to what `\the` achieves for
the `pt`.

## Macros of this package

All macros are expandable.  At time of writing they may not be
f-expandable, but (perhaps) in future final versions will expand fully
in two steps.  This refinement is anyhow not really important as TeX
engines now support the `\expanded` primitive.

Negative dimensions behave as if replaced by their absolute value, then
at last step the sign (if result is not zero) is applied.

1. At time of writing only the `\texdimin<uu>` macros are implemented,
The envisioned "down" and "up" variants are not done yet.

2. (not yet) For input `X` equal to (or sufficiently close to)
`\maxdimen` and those units `uu` for which `\maxdimen` is not exactly
representable (i.e. all units except `pt`, `bp` and `nd`), the output `D`
of the "up" macros `\texdimin<uu>u{X}`, if used as `Duu` in a dimension
assignment or expression, will (naturally) trigger a "Dimension too large"
error.

3. For `dd`, `nc` and `in`, and input `X` equal to (or sufficiently
close to) `\maxdimen` it turns out that `\texdimin<uu>{X}` produces an
output `D` such that `Duu` is the first "virtually attainable" TeX
dimension *beyond* `\maxdimen`.  Hence `Duu` will trigger on use
"Dimension too large error".

4. (not yet) For some units the "down" and "up" macros may trigger
"Dimension too large" during their execution if used with an input too
close to `\maxdimen`. "Safe" variants which are guaranteed never to
trigger this error but have some extra overhead to filter out inputs too
close to `\maxdimen` will *perhaps* be provided. But
see 2. and 3. regarding the usability of the output anyhow.

`\texdiminpt{<dim. expr.>}`

> Does `\the\dimexpr <dim. expr.> \relax` then removes the `pt`.

`\texdiminbp{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> bp` represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> `\maxdimen` on input produces `16322.78954` and indeed is realized as `16322.78954bp`.

`\texdiminbpdown{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> bp` represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

`\texdiminbpup{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> bp` represents the dimension exactly if possible. If not possible it
> will be larger by `1sp` from the original dimension.

`\texdiminndown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> nd` represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> `\maxdimen` on input produces `15355.51532` and indeed is realized as `15355.51532nd`.

`\texdiminnddown{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> nd` represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

`\texdiminndup{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> nd` represents the dimension exactly if possible. If not possible it
> will be larger by `1sp` from the original dimension.

`\texdiminddown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> dd` represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> Warning: the output for `\maxdimen` is `15312.02585` but `15312.02585dd`
> will trigger "Dimension too large" error.
> `\maxdimen-1sp` is attainable via `15312.02584dd`.

`\texdimindddown{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> dd` represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

`\texdiminddup{<dim. expr.>}` NOT YET

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

`\texdiminmmdown{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> mm` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdiminmmup{<dim. expr.>}` NOT YET

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

`\texdiminpcdown{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> pc` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdiminpcup{<dim. expr.>}` NOT YET

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

`\texdiminncdown{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> nc` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdiminncup{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> nc` represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.

`\texdimincc{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `D
> cc` represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> `\maxdimen` as input produces on output `1276.00215` and indeed the
> maximal attainable dimension is `1276.00215cc` (`1073741821sp`).

`\texdiminccdown{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> cc` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdiminccup{<dim. expr.>}` NOT YET

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

`\texdimincmdown{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> cm` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdimincmup{<dim. expr.>}` NOT YET

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

`\texdiminindown{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> in` represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdimininup{<dim. expr.>}` NOT YET

> Produces a decimal (with up to five decimal places) `D` such that `D
> in` represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.

## TODO

Implement the "up" and "down" variants.

Provide a macro `\texdimnearest{in,cm}{<dim.expr.>}` which would output
the nearest dimension simultaneously representable both in `in` and in
`cm`?

According to a reference on the web by an anonymous contributor the
dimensions representable with both `in` and `cm` units have the shape
`trunc(3613.5*k) sp` for some integer `k`. So we basically may have a
delta up to about `1800sp` which is about `0.0275pt` and is still small
(less than one hundredth of a millimeter, i.e. less than ten micron),
so perhaps such a utility for
"safe dimensions" may be useful.  Here are for example the dimensions
nearest to `1in` and realizable both in `in` and `cm` units:

    >>> \input texdimens.tex\relax
    (executing \input texdimens.tex\relax  in background)
    (./texdimens.tex) 
    >>> &exact
    exact mode (floating point evaluations use 16 digits)
    >>> (\texdiminin{4737298sp});
    @_10    1.00021
    >>> (\texdimincm{4737298sp});
    @_11    2.54054
    >>> (\dimexpr1.00021in, \dimexpr2.54054cm);
    @_12    4737298, 4737298
    >>> (\texdiminin{4733685sp});
    @_13    0.99945
    >>> (\texdimincm{4733685sp});
    @_14    2.5386
    >>> (\dimexpr0.99945in, \dimexpr2.5386cm);
    @_15    4733685, 4733685

As promised, one of them, the upper approximation, is at less than
one hundredth of millimeter from the two nearby targets.

Simpler however and more efficient
would be for people to finally adopt the French revolution Système
Métrique (rather than setting up giant financial paradises).

<!--
%! Local variables:
%! sentence-end-double-space: t
%! fill-column: 72
%! End:
-->
