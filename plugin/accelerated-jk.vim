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

if exists("g:accelerated_jk_loaded")
    finish
endif
let g:accelerated_jk_loaded = 1

if !exists("g:accelerated_jk_acceleration_table")
    let g:accelerated_jk_acceleration_table = [10,7,5,4,3,2,2,2]
endif

let s:prev_j = getpos(".")
let s:prev_k = getpos(".")
let s:count = 0
let s:stage = 0
let s:alen = len(g:accelerated_jk_acceleration_table)

function! s:accelerate_gj()
    let pos = getpos(".")
    if pos!=s:prev_j
        let s:count = 0
        let s:stage = 0
    endif

    execute "normal ".(s:stage + 1)."gj"
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

function! s:accelerate_gk()
    let pos = getpos(".")
    if pos!=s:prev_k
        let s:count = 0
        let s:stage = 0
    endif

    execute "normal ".(s:stage + 1)."gk"
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

function! s:accelerate_j()
    let pos = getpos(".")
    if pos!=s:prev_j
        let s:count = 0
        let s:stage = 0
    endif

    let pos[1] += (s:stage + 1)
    call setpos(".", pos)
    let s:prev_j = pos

    if s:stage>=s:alen
        return
    endif

    let s:count += 1

    if g:accelerated_jk_acceleration_table[s:stage] < s:count
        let s:count = 0
        let s:stage += 1
    endif
endfunction

function! s:accelerate_k()
    let pos = getpos(".")
    if pos!=s:prev_k
        let s:count = 0
        let s:stage = 0
    endif

    let pos[1] -= (s:stage + 1)
    call setpos(".", pos)
    let s:prev_k = pos

    if s:stage>=s:alen
        return
    endif

    let s:count += 1

    if g:accelerated_jk_acceleration_table[s:stage] < s:count
        let s:count = 0
        let s:stage += 1
    endif
endfunction

nnoremap <Plug>(accelerated_jk_gj) :<C-u>call <SID>accelerate_gj()<CR>
nnoremap <Plug>(accelerated_jk_gk) :<C-u>call <SID>accelerate_gk()<CR>
nnoremap <Plug>(accelerated_jk_j) :<C-u>call <SID>accelerate_j()<CR>
nnoremap <Plug>(accelerated_jk_k) :<C-u>call <SID>accelerate_k()<CR>
