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

if !exists("g:accelerated_jk_acceleration_table")
    let g:accelerated_jk_acceleration_table = [10,7,5,4,3,2,2,2]
endif

nnoremap <silent><Plug>(accelerated_jk_gj) :<C-u>call accelerated#j(1)<CR>
nnoremap <silent><Plug>(accelerated_jk_gk) :<C-u>call accelerated#k(1)<CR>
nnoremap <silent><Plug>(accelerated_jk_j) :<C-u>call accelerated#j(0)<CR>
nnoremap <silent><Plug>(accelerated_jk_k) :<C-u>call accelerated#k(0)<CR>
