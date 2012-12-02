let s:save_cpo = &cpo
set cpo&vim

" function to compare with sort
function! s:acc_table_cmp(a, b) "{{{
    return a:a - a:b
endfunction
"}}}

" script-local variables "{{{
let s:key_count = 0
let s:prev_j_pos = getpos('.')
let s:prev_k_pos = copy(s:prev_j_pos)
let s:prev_gj_pos = copy(s:prev_j_pos)
let s:prev_gk_pos = copy(s:prev_j_pos)
let s:acceleration_table = sort(deepcopy(g:accelerated_jk_acceleration_table), 's:acc_table_cmp')
let s:end_of_count = s:acceleration_table[-1]
"}}}

" delete functions to sort "{{{
delfunction s:acc_table_cmp
"}}}

" reset event
function! accelerated#position_driven#reset() "{{{
    let s:key_count = 0
endfunction

augroup accelerated-jk-position-driven-reset
    autocmd!
    autocmd CursorHold,CursorHoldI * call accelerated#position_driven#reset()
augroup END
 "}}}

function! s:calc_acceleration_step() "{{{
    let acc_len = len(s:acceleration_table)
    for idx in range(acc_len)
        if s:key_count < s:acceleration_table[idx]
            return idx + 1
        endif
    endfor
    return acc_len + 1
endfunction
"}}}

" accelerate {cmd} by position
function! accelerated#position_driven#command(cmd) "{{{
    if v:count
        execute 'normal!' v:count.a:cmd
        return
    endif

    if s:prev_{a:cmd}_pos != getpos('.')
        let s:key_count = 0
    endif

    let step = s:calc_acceleration_step()
    execute 'normal!' step.a:cmd

    if s:key_count < s:end_of_count
        let s:key_count += 1
    endif
    let s:prev_{a:cmd}_pos = getpos('.')
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
