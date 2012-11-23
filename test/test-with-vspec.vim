set rtp +=..
runtime! plugin/accelerated-jk.vim

function! GenRand(max)
    let rand = system('echo $RANDOM')
    return (rand=='' ? localtime() : rand) % a:max
endfunction

describe 'default values and mappings'
    it 'provides default <Plug> mappings'
        Expect maparg('<Plug>(accelerated_jk_gj)') != ''
        Expect maparg('<Plug>(accelerated_jk_gk)') != ''
        Expect maparg('<Plug>(accelerated_jk_j)') != ''
        Expect maparg('<Plug>(accelerated_jk_k)') != ''
    end

    it 'provides default acceleration table and reset setting'
        Expect g:accelerated_jk_acceleration_table == [7,12,17,21,24,26,28,30]
        Expect g:accelerated_jk_deceleration_table == [[150, 9999]]
    end
end

describe 'acceleration'
    before
        nmap j <Plug>(accelerated_jk_j)
        nmap gj <Plug>(accelerated_jk_gj)
        nmap k <Plug>(accelerated_jk_k)
        nmap gk <Plug>(accelerated_jk_gk)
        new
        0read! for i in `seq 1000`; do; echo $i; done
    end

    it 'accelerates j moving'
        normal! gg
        let type_count = 0
        for idx in range(len(g:accelerated_jk_acceleration_table))
            let stage = idx + 1
            while type_count < g:accelerated_jk_acceleration_table[idx]
                let prev_line = line('.')
                normal gj
                Expect prev_line + stage == line('.')
                let type_count += 1
            endwhile
        endfor
    end

    it 'accelerates k moving'
        normal! G
        let type_count = 0
        for idx in range(len(g:accelerated_jk_acceleration_table))
            let stage = idx + 1
            while type_count < g:accelerated_jk_acceleration_table[idx]
                let prev_line = line('.')
                normal gk
                Expect prev_line - stage == line('.')
                let type_count += 1
            endwhile
        endfor
    end

    it 'provides the same steps in both j and k mapping'
        for _ in range(10)
            let start = GenRand(100)
            let step = GenRand(50)
            execute start
            for __ in range(step)
                normal gj
            endfor
            for __ in range(step)
                normal gk
            endfor
            Expect line('.') == start
        endfor
    end

    it 'makes j and k repeats no change'
        execute 500
        let num = GenRand(50)
        for _ in range(num)
            normal gj
            normal gk
        endfor
        Expect line('.') == 500
    end

    it 'resets moving when 150 mille seconds have passed after last j/k moving'
        let start_steps = GenRand(40)
        normal! gg
        for _ in range(start_steps)
            normal gj
        endfor

        let before = line('.')
        normal gj
        Expect line('.') == before+len(g:accelerated_jk_acceleration_table)

        let before = line('.')
        sleep 200m
        normal gj
        Expect line('.') == before+1
    end

    after
        nunmap j
        nunmap gj
        nunmap k
        nunmap gk
        close!
    end
end

describe 'deceleration'
    before
        unlet! g:accelerated_jk_deceleration_table
        let g:accelerated_jk_enable_deceleration = 1
        runtime! plugin/accelerated-jk.vim
        runtime! autoload/accelerate.vim
        nmap j <Plug>(accelerated_jk_j)
        nmap gj <Plug>(accelerated_jk_gj)
        new
        0read! for i in `seq 1000`; do; echo $i; done
    end

    it 'has a default deceleration table'
        Expect g:accelerated_jk_deceleration_table ==
                    \ [[150, 3], [300, 7], [450, 11], [600, 15], [750, 23], [900, 28], [1050, 9999]]
    end

    it 'decelerates cursor when g:accelerated_jk_enable_deceleration is 1'

        function! s:check_deceleration_after(elapsed, step)
            echo 'check after '.a:elapsed.' msec. '.a:step.' steps is expected.'
            execute 1
            for _ in range(30)
                normal gj
            endfor
            let before = line('.')
            execute 'sleep' a:elapsed.'m'
            normal gj
            Expect line('.') == before + a:step
        endfunction

        call s:check_deceleration_after(100, 8)
        call s:check_deceleration_after(200, 7)
        call s:check_deceleration_after(500, 3)
        call s:check_deceleration_after(650, 2)
        call s:check_deceleration_after(800, 2)
        call s:check_deceleration_after(950, 1)

        delfunction s:check_deceleration_after
    end

    after
        nunmap j
        nunmap gj
        close!
        unlet g:accelerated_jk_enable_deceleration
    end
end

" vim: set ft=conf:
