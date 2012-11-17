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

function! s:dec_table_cmp(a, b)
    return a:a[0] == a:b[0] ? 0 : a:a[0] > a:b[0] ? 1 : -1
endfunction

let s:prev_j = getpos(".")
let s:prev_k = getpos(".")
let s:prev_j_reltime = []
let s:prev_k_reltime = []
let s:count = 0
let s:stage = 0
let s:alen = len(g:accelerated_jk_acceleration_table)
let s:dec_table = sort(deepcopy(g:accelerated_jk_deceleration_table), 's:dec_table_cmp')

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

    call s:decelerate('j')

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

    call s:decelerate('k')

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

function! s:decelerate(dir)
    if !empty(s:dec_table) && !empty(s:prev_{a:dir}_reltime)
        " Calculate delta millisecond.
        let reltimestr = reltimestr(reltime(s:prev_{a:dir}_reltime))
        let [sec, microsec] = matchlist(reltimestr, '\(\d\+\)\.0*\(\d\+\)')[1:2]    " 0* removes leading zeroes.
        let msec = str2nr(sec) * 1000 + str2nr(microsec) / 1000

        " Find applicable entry.
        let dec = [0, 0, 0]
        for i in range(len(s:dec_table))
            if msec < s:dec_table[i][0]
                " Assert dec == s:dec_table[i-1]
                break
            endif
            let dec = s:dec_table[i]
        endfor

        " Subtract dec_count from s:count and s:stage.
        " NOTE: 'dec[1] > 0' gets rid of
        " invalid value of dec_table.
        let dec_count = dec[1]
        while dec_count > 0
            if dec_count <= s:count
                let s:count -= dec_count
                break    " end.
            else
                let dec_count -= s:count
                if s:stage == 0
                    let s:count = 0
                    break
                else
                    let s:stage -= 1
                    let s:count = g:accelerated_jk_acceleration_table[s:stage]
                endif
            endif
        endwhile
    endif
    let s:prev_{a:dir}_reltime = reltime()
endfunction
