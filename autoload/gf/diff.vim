" gf-diff - Go to a hunk from diff output
" Version: @@VERSION@@
" Copyright (C) 2011-2012 Kana Natsuno <http://whileimautomaton.net/>
" License: So-called MIT/X license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Interface  "{{{1
function! gf#diff#find()  "{{{2
  let d = gf#diff#investigate_the_hunk_under_the_cursor()
  return
  \ d is 0
  \ ? 0
  \ : {
  \     'path': d.to_path,
  \     'line': gf#diff#calculate_better_lineno('to', d),
  \     'col': 0,
  \   }
endfunction








" Misc.  "{{{1
function! gf#diff#parse_hunk_header_line(line)  "{{{2
  " Line -> Maybe (LineNo, LineNo)
  let parts = matchlist(a:line, '^@@ -\(\d\+\),\d\+ +\(\d\+\),\d\+ @@')
  return parts == [] ? 0 : map(parts[1:2], 'str2nr(v:val, 10)')
endfunction




function! gf#diff#parse_hunk(lines)  "{{{2
  " [Line] -> (LineOffset, LineOffset)
  let firstly_deleted_offset = -1
  for i in range(len(a:lines))
    if a:lines[i][0:0] == '-'
      let firstly_deleted_offset = i - 1
      break
    endif
  endfor

  let firstly_inserted_offset = -1
  for i in range(len(a:lines))
    if a:lines[i][0:0] == '+'
      let firstly_inserted_offset = i - 1
      break
    endif
  endfor

  return [firstly_deleted_offset, firstly_inserted_offset]
endfunction




function! gf#diff#parse_diff_header_line(line)  "{{{2
  " Line -> Maybe (LineNo, LineNo)
  let parts = matchlist(a:line, '\v^diff \-\-git %(a\/)?(\S+) %(b\/)?(\S+)$')
  return parts == [] ? 0 : parts[1:2]
endfunction




function! gf#diff#investigate_the_hunk_under_the_cursor()  "{{{2
  " <<<CurrentBuffer>>> -> VariousInformation
  " FIXME: Support more diff formats other than Git diff.
  let original_position = getpos('.')
    let d = s:investigate_the_hunk_under_the_cursor()
  call setpos('.', original_position)

  return d
endfunction

function! s:investigate_the_hunk_under_the_cursor()
  let d = {}

  let [hunk_lineno, _] = searchpos('\v^\@\@ ', 'bcW')
  if hunk_lineno == 0
    return 0
  endif
  let xs = gf#diff#parse_hunk_header_line(getline(hunk_lineno))
  if xs is 0
    return 0
  endif
  let [d.from_first_lineno, d.to_first_lineno] = xs

  let [next_block_lineno, _] = searchpos('\v^(\@\@ |diff )', 'nW')
  if next_block_lineno == 0
    let next_block_lineno = line('$')
  endif
  let [d.firstly_deleted_offset, d.firstly_inserted_offset] =
        \ gf#diff#parse_hunk(getline(hunk_lineno, next_block_lineno))

  let [diff_header_lineno, _] = searchpos('^diff ', 'bW')
  if diff_header_lineno == 0
    return 0
  endif
  let xs = gf#diff#parse_diff_header_line(getline(diff_header_lineno))
  if xs is 0
    return 0
  endif
  let [d.from_path, d.to_path] = xs

  return d
endfunction




function! gf#diff#calculate_better_lineno(type, d)  "{{{2
  " Type -> HunkInfo -> LineNo
  " FIXME: Reverse offset usage for non-Git diff if a:type ==# 'from'.
  let lineno = a:type ==# 'from' ? a:d.from_first_lineno : a:d.to_first_lineno
  if a:d.firstly_deleted_offset == -1 && a:d.firstly_inserted_offset == -1
    return lineno + 0
  elseif a:d.firstly_deleted_offset == -1 && a:d.firstly_inserted_offset != -1
    return lineno + a:d.firstly_inserted_offset
  elseif a:d.firstly_deleted_offset != -1 && a:d.firstly_inserted_offset == -1
    return
    \ lineno +
    \ (a:d.firstly_deleted_offset == 0 ? 0 : a:d.firstly_deleted_offset - 1)
  else " a:firstly_deleted_offset != -1 && a:firstly_inserted_offset != -1
    " FIXME: Use smaller offset.
    return
    \ lineno +
    \ (a:d.firstly_deleted_offset == 0 ? 0 : a:d.firstly_deleted_offset - 1)
  endif
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
