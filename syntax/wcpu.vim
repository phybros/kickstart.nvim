" Vim syntax file for WCPU-1 assembly (.w files)

if exists("b:current_syntax")
  finish
endif

" Case insensitive keywords
syn case ignore

" Comments: ; to end of line
syn match wcpuComment ";.*$"

" Labels: identifier followed by : at start of line
syn match wcpuLabel "^\s*\w\+:" contains=NONE

" Constants: name = value
syn match wcpuConstant "^\s*\w\+\s*=" contains=wcpuConstName
syn match wcpuConstName "\w\+" contained

" Instructions
syn keyword wcpuKeyword nop out outa outb outx outg
syn keyword wcpuKeyword tax txa tab tba tag tga tsx txs
syn keyword wcpuKeyword lsp
syn keyword wcpuKeyword add addb addx addg sub subb subx subg cmp cmpb cmpx cmpg
syn keyword wcpuKeyword lda ldb ldx ldg sta stb stx stg
syn keyword wcpuKeyword jmp jsr rts jc jnc jz jnz
syn keyword wcpuKeyword pha pla phb plb phx plx phg plg

" Immediate prefix: # before $hex or constant name (orange #, value keeps its own color)
syn match wcpuImmediatePrefix "#\ze[\$a-zA-Z_]" contains=NONE

" Immediate values: #decimal or #0xHex (all orange)
syn match wcpuImmediate "#\(0x\)\?\x\+" contains=NONE

" Absolute addresses: $decimal or $0xHex
syn match wcpuAbsolute "\$\(0x\)\?\x\+" contains=NONE

" Bare number literals
syn match wcpuNumber "\<\(0x\)\?\x\+\>" contains=NONE

hi def link wcpuComment Comment
hi def link wcpuLabel Label
hi def link wcpuConstant Operator
hi def link wcpuConstName Define
hi def link wcpuKeyword Statement
hi def link wcpuImmediatePrefix Number
hi def link wcpuImmediate Number
hi def link wcpuAbsolute Special
hi def link wcpuNumber Number
hi wcpuConstUse ctermfg=Green guifg=#50fa7b

" Dynamically highlight constant names at usage sites
function! s:HighlightWcpuConstants()
  syn clear wcpuConstUse
  for line in getline(1, '$')
    let m = matchstr(line, '^\s*\zs\w\+\ze\s*=')
    if !empty(m)
      execute 'syn match wcpuConstUse "\<' . m . '\>" containedin=ALLBUT,wcpuComment,wcpuConstant'
    endif
  endfor
endfunction

call s:HighlightWcpuConstants()
augroup wcpu_const_highlight
  autocmd!
  autocmd BufWritePost,TextChanged,TextChangedI <buffer> call s:HighlightWcpuConstants()
augroup END

let b:current_syntax = "wcpu"
