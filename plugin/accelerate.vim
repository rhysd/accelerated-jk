if exists("g:accelerate_loaded")
    finish
endif
let g:accelerate_loaded = 1

if !exists("g:accelerate_acceleration_table")
    let g:accelerate_acceleration_table = [10,7,5,4,3,2,2,2]
endif

let s:prev_j = getpos(".")
let s:prev_k = getpos(".")
let s:count = 0
let s:stage = 0
let s:alen = len(g:accelerate_acceleration_table)

function! Accelerate_gj()
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

    if g:accelerate_acceleration_table[s:stage] < s:count
        let s:count = 0
        let s:stage += 1
    endif
endfunction

function! Accelerate_gk()
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

    if g:accelerate_acceleration_table[s:stage] < s:count
        let s:count = 0
        let s:stage += 1
    endif
endfunction

function! Accelerate_j()
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

    if g:accelerate_acceleration_table[s:stage] < s:count
        let s:count = 0
        let s:stage += 1
    endif
endfunction

function! Accelerate_k()
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

    if g:accelerate_acceleration_table[s:stage] < s:count
        let s:count = 0
        let s:stage += 1
    endif
endfunction

if !exists("g:accelerate_default_enable_g") || g:accelerate_default_anable_g
    nnoremap <silent>j :call Accelerate_gj()<CR>
    nnoremap <silent>k :call Accelerate_gk()<CR>
elseif !exists("g:accelerate_default_anable") || g:accelerate_default_anable
    nnoremap <silent>j :call Accelerate_j()<CR>
    nnoremap <silent>k :call Accelerate_k()<CR>
endif

