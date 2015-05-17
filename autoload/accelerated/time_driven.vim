let s:save_cpo = &cpo
set cpo&vim

" function to compare with sort
function! s:acc_table_cmp(a, b) "{{{
    return a:a - a:b
endfunction

function! s:dec_table_cmp(a, b)
    return a:a[0] - a:b[0]
endfunction
"}}}

" script-local variables "{{{
let s:key_count = 0
let s:acceleration_table = sort(deepcopy(g:accelerated_jk_acceleration_table), 's:acc_table_cmp')
let s:deceleration_table = sort(deepcopy(g:accelerated_jk_deceleration_table), 's:dec_table_cmp')
let s:end_of_count = s:acceleration_table[-1]
"}}}

" delete functions to sort "{{{
delfunction s:dec_table_cmp
delfunction s:acc_table_cmp
"}}}

" decelerate key typing count
function! s:deceleration(delay) "{{{
    let deceleration_count = s:deceleration_table[-1][1]
    let prev_dec_count = 0
    for [elapsed, dec_count] in s:deceleration_table
        if elapsed > a:delay
            let deceleration_count = prev_dec_count
            break
        else
            let prev_dec_count = dec_count
        endif
    endfor
    let s:key_count = s:key_count - deceleration_count < 0 ?
                        \ 0 : s:key_count - deceleration_count
endfunction
"}}}

" calculate j/k jump step
function! s:acceleration_step() "{{{
    let len = len(s:acceleration_table)
    for idx in range(len)
        if s:acceleration_table[idx] > s:key_count
            return idx + 1
        endif
    endfor
    return len
endfunction
"}}}

" accelerate {cmd} by time
function! accelerated#time_driven#command(cmd) "{{{

    " if specified count, move like original j/k command
    if v:count
        execute 'normal!' v:count.a:cmd
        return
    endif

    " check timestamp
    let previous_timestamp = get(s:, a:cmd.'_timestamp_micro_seconds', [0, 0])
    let current_timestamp = reltime()
    let [delta_head, delta_tail] = split(reltimestr(reltime(
                \ previous_timestamp, current_timestamp)), '\.')
    let msec = str2nr(delta_head . delta_tail[0:2])

    if msec > g:accelerated_jk_acceleration_limit
        call s:deceleration(msec)
    endif

    let step = s:acceleration_step()

    " execute command with step count
    execute 'normal!' step.a:cmd

    " prepare for next j/k
    if s:key_count < s:end_of_count
        let s:key_count += 1
    endif
    let s:{a:cmd}_timestamp_micro_seconds = current_timestamp
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
