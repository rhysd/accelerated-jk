" Copyright (c) 2012 rhysd
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
" of the Software, and to permit persons to whom the Software is furnished to do so,
" subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
" INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
" PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
" TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
" THE USE OR OTHER DEALINGS IN THE SOFTWARE.


" Check if deceleration is enabled.
let g:accelerated_jk_enable_deceleration = get(g:, 'accelerated_jk_enable_deceleration', 0)
let g:accelerated_jk_acceleration_limit = get(g:, 'accelerated_jk_acceleration_limit', 150)

" Acceleration rate.
if !exists("g:accelerated_jk_acceleration_table")
    let g:accelerated_jk_acceleration_table = [7,12,17,21,24,26,28,30]
endif


" Reset speed if 1 second has passed.
" If deceleration is used, default deceleration is set.
"   - Customizing this table is recomended because checking a gap of time
"     is affected by OS's key repeat setting and other factors.
"   - Table is constructed of arrays having two elements.
"     - first element:  elapsed time after last j/k typed.
"     - second element: count to decelerate which is used in acceleration
"       table.
if !exists("g:accelerated_jk_deceleration_table")
    if g:accelerated_jk_enable_deceleration
        let g:accelerated_jk_deceleration_table =
                    \ [[200, 3], [300, 7], [450, 11], [600, 15], [750, 21], [900, 9999]]
    else
        let g:accelerated_jk_deceleration_table = [[150, 9999]]
    endif
endif

" mappings
nnoremap <silent><Plug>(accelerated_jk_gj) :<C-u>call accelerate#cmd('gj')<CR>
nnoremap <silent><Plug>(accelerated_jk_gk) :<C-u>call accelerate#cmd('gk')<CR>
nnoremap <silent><Plug>(accelerated_jk_j)  :<C-u>call accelerate#cmd('j')<CR>
nnoremap <silent><Plug>(accelerated_jk_k)  :<C-u>call accelerate#cmd('k')<CR>
