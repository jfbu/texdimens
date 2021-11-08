archiving here some documentation relative to how close to \maxdimen
one could use the old and up macros for dd, nc, and in

`\texdimendd{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Ddd`
> represents the dimension exactly if possible. If not possible it
> will differ by `1sp` from the original dimension, but it is not
> known in advance if it will be above or below.

> Warning: the output for `\maxdimen` is `15312.02585` but `15312.02585dd`
> will trigger on use "Dimension too large" error.
> `\maxdimen-1sp` is the maximal input for which the output remains
> less than `\maxdimen` (max attainable dimension: `\maxdimen-1sp`).

`\texdimendddown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Ddd`
> represents the dimension exactly if possible. If not possible it
> will be smaller by `1sp` from the original dimension.

`\texdimendddownlegacy{<dim. expr.>}`

> The earlier version from 0.9 gamma release,
> It requires input to be at most `\maxdimen-1sp`.

`\texdimenddup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Ddd`
> represents the dimension exactly if possible. If not possible it
> will be larger by `1sp` from the original dimension.
> If input is `\maxdimen`, then `Ddd` virtually represents `\maxdimen+1sp`.

`\texdimendduplegacy{<dim. expr.>}`

> The earlier versions from 0.9 gamma release,
> It requires input to be at most `\maxdimen-1sp`.

`\texdimennc{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dnc`
> represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> Warning: the output for `\maxdimen-1sp` is `1279.62628` but `1279.62628nc`
> will trigger on use "Dimension too large" error.
> `\maxdimen-2sp` is the maximal input for which the output remains
> less than `\maxdimen` (max attainable dimension: `\maxdimen-9sp`).

`\texdimenncdown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dnc`
> represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdimenncdownlegacy{<dim. expr.>}`

> The earlier version from 0.9 gamma release,
> It requires input to be at most `\maxdimen-2sp`.

`\texdimenncup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Dnc`
> represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.
> If input is `>\maxdimen-9sp`, then `Dnc` triggers on use "Dimension too large".

`\texdimenncuplegacy{<dim. expr.>}`

> The earlier version from 0.9 gamma release,
> It requires input to be at most `\maxdimen-2sp`.


`\texdimenin{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Din`
> represents the dimension exactly if possible. If not possible it
> will either be the closest from below or from above, but it is not
> known in advance which one (and it is not known if the other choice
> would have been closer).

> Warning: the output for `\maxdimen-18sp` is `226.70541` but `226.70541in`
> will trigger on  use "Dimension too large" error.
> `\maxdimen-19sp` is the maximal input for which the output remains
> less than `\maxdimen` (max attainable dimension: `\maxdimen-55sp`).

`\texdimenindown{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Din`
> represents the dimension exactly if possible. If not possible it
> will be largest representable dimension smaller than the original one.

`\texdimenindownlegacy{<dim. expr.>}`

> The earlier version from 0.9 gamma release,
> It requires input to be at most `\maxdimen-19sp`.

`\texdimeninup{<dim. expr.>}`

> Produces a decimal (with up to five decimal places) `D` such that `Din`
> represents the dimension exactly if possible. If not possible it
> will be smallest representable dimension larger than the original one.
> If input is `>\maxdimen-55sp`, then `Din` triggers on use "Dimension too large".

`\texdimeninuplegacy{<dim. expr.>}`

> The earlier version from 0.9 gamma release,
> It requires input to be at most `\maxdimen-19sp`.

