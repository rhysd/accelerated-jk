## Vim plugin to accelerate up-down moving (`j` and `k` mapping)

If you want to change acceleration steps, define `g:accelerated_jk_acceleration_table`.

Speed of cursor resets when 1 second has passed after last typing of `j` or `k`.

If you want to decelerate a cursor moving by time, set `g:accelerated_jk_enable_deceleration` to `1`.
In addition, if you want to change deceleration rate, set `g:accelerated_jk_deceleration_table` to
a proper value. See `plugin/accelerated-jk.vim` to get more information.

Example of setting is below.

```VimL
let g:accelerated_jk_enable_deceleration = 1
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
```

This plugin is distributed under MIT License.
