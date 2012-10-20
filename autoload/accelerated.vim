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

if exists("g:accelerated_loaded")
    finish
endif
let g:accelerated_loaded = 1

let s:prev_j = getpos(".")
let s:prev_k = getpos(".")
let s:count = 0
let s:stage = 0
let s:alen = len(g:accelerated_jk_acceleration_table)

function! accelerated#j(exclusive)
    if v:count
        execute 'normal!' v:count.(a:exclusive ? 'gj' : 'j')
        return
    endif

    let pos = getpos(".")
    if pos!=s:prev_j
        let s:count = 0
        let s:stage = 0
    endif

    execute "normal!" (s:stage + 1).(a:exclusive ? 'gj' : 'j')
    let s:prev_j = getpos(".")

    if s:stage>=s:alen
        return
    endif

    let s:count += 1

    if g:accelerated_jk_acceleration_table[s:stage] < s:count
        let s:count = 0
        let s:stage += 1
    endif
endfunction

function! accelerated#k(exclusive)
    if v:count
        execute 'normal!' v:count.(a:exclusive ? 'gk' : 'k')
        return
    endif

    let pos = getpos(".")
    if pos!=s:prev_k
        let s:count = 0
        let s:stage = 0
    endif

    execute "normal!" (s:stage + 1).(a:exclusive ? 'gk' : 'k')
    let s:prev_k = getpos(".")

    if s:stage>=s:alen
        return
    endif

    let s:count += 1

    if g:accelerated_jk_acceleration_table[s:stage] < s:count
        let s:count = 0
        let s:stage += 1
    endif
endfunction
