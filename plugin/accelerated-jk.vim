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

let s:save_cpo = &cpo
set cpo&vim

" Check if deceleration is enabled.
let g:accelerated_jk_enable_deceleration = get(g:, 'accelerated_jk_enable_deceleration', 0)

" function to compare with sort
function! s:table_cmp(a, b)
    return a:a[0] == a:b[0] ? 0 : a:a[0] > a:b[0] ? 1 : -1
endfunction

" Check acceleration rate.
if !exists("g:accelerated_jk_acceleration_table")
    let g:accelerated_jk_acceleration_table = [7,12,17,21,24,26,28,30]
else
    let g:accelerated_jk_acceleration_table =
                \ sort(g:accelerated_jk_acceleration_table, 's:table_cmp')
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
                    \ [[150, 3], [300, 7], [450, 11], [600, 15], [750, 23], [900, 28], [1050, 9999]]
    else
        let g:accelerated_jk_deceleration_table = [[150, 9999]]
    endif
else
    let g:accelerated_jk_deceleration_table =
                \ sort(g:accelerated_jk_deceleration_table, 's:table_cmp')
endif

" mappings
nnoremap <silent><Plug>(accelerated_jk_gj) :<C-u>call <SID>accelerated('gj')<CR>
nnoremap <silent><Plug>(accelerated_jk_gk) :<C-u>call <SID>accelerated('gk')<CR>
nnoremap <silent><Plug>(accelerated_jk_j)  :<C-u>call <SID>accelerated('j')<CR>
nnoremap <silent><Plug>(accelerated_jk_k)  :<C-u>call <SID>accelerated('k')<CR>



" implementation
"   NOTE:
"   j/k mappings are almost always used when using Vim.
"   So, there is no benefit of implementing this plugin in /autoload.

let s:key_count = 0
let s:end_of_count = g:accelerated_jk_acceleration_table[-1]
let s:acceleration_limit = g:accelerated_jk_deceleration_table[0][0]

for cmd in ['j', 'gj', 'k', 'gk']
    let s:{cmd}_timestamp_micro_seconds = [0, 0]
endfor

function! s:accelerated(cmd)

    " TODO
    " This is temporary implementation.
    if v:count
        execute 'normal!' v:count.a:cmd
        return
    endif

    let current_timestamp = reltime()
    let [sec, microsec] = reltime(s:{a:cmd}_timestamp_micro_seconds, current_timestamp)
    let msec = sec * 1000 + microsec / 1000

    " deceleration!
    if msec > s:acceleration_limit
        let deceleration_count = g:accelerated_jk_deceleration_table[-1][1]
        for [elapsed, dec_count] in g:accelerated_jk_deceleration_table
            if elapsed > msec
                let deceleration_count = dec_count
                break
            endif
        endfor
        let s:key_count = s:key_count - deceleration_count < 0 ?
                            \ 0 : s:key_count - deceleration_count
    endif

    " acceleration!
    " TODO improve implementation
    let stage = len(g:accelerated_jk_acceleration_table)
    for idx in range(len(g:accelerated_jk_acceleration_table))
        if g:accelerated_jk_acceleration_table[idx] > s:key_count
            let stage= idx+1
            break
        endif
    endfor

    " jump `stage` lines
    execute 'normal!' (stage).a:cmd

    " prepare for next j/k
    if s:key_count < s:end_of_count
        let s:key_count += 1
    endif
    let s:{a:cmd}_timestamp_micro_seconds = current_timestamp
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
