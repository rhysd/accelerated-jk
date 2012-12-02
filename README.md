## Vim plugin to accelerate up-down moving (`j` and `k` mapping)

This plugin accelerates `j`/`k` mappings' steps while `j` or `k` key is repeating.
If the interval of key-repeat takes more than 150 ms, the step is reset.
When you want to change this interval, set `g:accelerated_jk_acceleration_limit`.

If you want to change acceleration steps, define `g:accelerated_jk_acceleration_table`.

If you want to decelerate a cursor moving by time instead of reset, set `g:accelerated_jk_enable_deceleration` to `1`.
In addition, if you want to change deceleration rate, set `g:accelerated_jk_deceleration_table` to
a proper value. See `plugin/accelerated-jk.vim` to get more information.

Example of setting is below.

```VimL
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
```

If you don't want to control acceleration by time, position-driven acceleration is available.
Using position-driven acceleration makes a cursor move with more light steps than time-driven one makes.
However the check if j/k is repeated or not is more optimistic.
If you want to use position-driven acceleration, a setting would be like below.

```VimL
nmap j <Plug>(accelerated_jk_gj_position)
nmap k <Plug>(accelerated_jk_gk_position)
```

This plugin is distributed under MIT License.

    Copyright (c) 2012 rhysd

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
    of the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
    THE USE OR OTHER DEALINGS IN THE SOFTWARE.

