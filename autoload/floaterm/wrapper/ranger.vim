" ============================================================================
" FileName: ranger.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

function! floaterm#wrapper#ranger#(cmd) abort
  let s:ranger_tmpfile = tempname()
  let original_dir = getcwd()
  lcd %:p:h

  let cmdlist = split(a:cmd)
  let cmd = 'ranger --choosefiles=' . s:ranger_tmpfile
  if len(cmdlist) > 1
    let cmd .= ' ' . join(cmdlist[1:], ' ')
  else
    let cmd .= ' ' . shellescape(getcwd())
  endif

  exe "lcd " . original_dir
  return [cmd, {'on_exit': funcref('s:ranger_callback')}, v:false]
endfunction

function! s:ranger_callback(...) abort
  if filereadable(s:ranger_tmpfile)
    let filenames = readfile(s:ranger_tmpfile)
    if !empty(filenames)
      call floaterm#hide()
      for filename in filenames
        execute g:floaterm_open_command . ' ' . fnameescape(filename)
      endfor
    endif
  endif
endfunction
