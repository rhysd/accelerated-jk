let s:save_cpo = &cpo
set cpo&vim

" function to compare with sort
function! s:table_cmp(a, b)
    return a:a[0] == a:b[0] ? 0 : a:a[0] > a:b[0] ? 1 : -1
endfunction

let s:key_count = 0
let s:end_of_count = g:accelerated_jk_acceleration_table[-1]
let s:acceleration_limit = g:accelerated_jk_deceleration_table[0][0]
let s:acceleration_table = sort(deepcopy(g:accelerated_jk_acceleration_table, 's:table_cmp'))
let s:deceleration_table = sort(deepcopy(g:accelerated_jk_deceleration_table, 's:table_cmp'))

delfunction s:table_cmp

function! accelerate#cmd(cmd)

    " TODO
    " This is temporary implementation.
    if v:count
        execute 'normal!' v:count.a:cmd
        return
    endif

    let previous_timestamp = get(s:, a:cmd.'_timestamp_micro_seconds', [0, 0])
    let current_timestamp = reltime()
    let [sec, microsec] = reltime(previous_timestamp, current_timestamp)
    let msec = sec * 1000 + microsec / 1000

    " deceleration!
    if msec > s:acceleration_limit
        let deceleration_count = s:deceleration_table[-1][1]
        for [elapsed, dec_count] in s:deceleration_table
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
    let step = len(s:acceleration_table)
    for idx in range(len(s:acceleration_table))
        if s:acceleration_table[idx] > s:key_count
            let step = idx+1
            break
        endif
    endfor

    " jump `stage` lines
    execute 'normal!' step.a:cmd

    " prepare for next j/k
    if s:key_count < s:end_of_count
        let s:key_count += 1
    endif
    let s:{a:cmd}_timestamp_micro_seconds = current_timestamp
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
