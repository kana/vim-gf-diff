describe 'gf#diff#parse_hunk_header_line'
  it 'works'
    Expect gf#diff#parse_hunk_header_line('@@ -787,14 +787,6 @@') == [787, 787]
    Expect gf#diff#parse_hunk_header_line('@@ -803,6 +1795,14 @@') == [803, 1795]
    Expect gf#diff#parse_hunk_header_line('@@ -803,6 +1795,14 @@ main(ac, av)') == [803, 1795]
    Expect gf#diff#parse_hunk_header_line('@ -1803,6 +1795,14 @@') == 0
    Expect gf#diff#parse_hunk_header_line('@@ -1803,6 +1795,14 @') == 0
  end
end

describe 'gf#diff#parse_hunk'
  it 'works'
    Expect gf#diff#parse_hunk(['@@ ...', '', '', '', '']) == [-1, -1]
    Expect gf#diff#parse_hunk(['@@ ...', '', '+', '', '']) == [-1, 1]
    Expect gf#diff#parse_hunk(['@@ ...', '', '', '-', '']) == [2, -1]
    Expect gf#diff#parse_hunk(['@@ ...', '', '+', '-', '']) == [1, 1]
  end
end

describe 'gf#diff#parse_diff_header_line'
  it 'works'
    Expect gf#diff#parse_diff_header_line('diff --git a/foo/bar/baz.qux b/foo/bar/baz.qux') == ['foo/bar/baz.qux', 'foo/bar/baz.qux']
    Expect gf#diff#parse_diff_header_line('diff --git a/foo/bar/baz.qux foo/bar/baz.qux') == ['foo/bar/baz.qux', 'foo/bar/baz.qux']
    Expect gf#diff#parse_diff_header_line('diff --git foo/bar/baz.qux b/foo/bar/baz.qux') == ['foo/bar/baz.qux', 'foo/bar/baz.qux']
    Expect gf#diff#parse_diff_header_line('diff --git foo/bar/baz.qux foo/bar/baz.qux') == ['foo/bar/baz.qux', 'foo/bar/baz.qux']
    Expect gf#diff#parse_diff_header_line('diff --git a/foo.c b/bar.c') == ['foo.c', 'bar.c']
  end
end

describe 'gf#diff#investigate_the_hunk_under_the_cursor'
  before
    tabnew
  end

  after
    %bwipeout!
  end

  it 'works'
    let text = [
    \   'commit 3d7b818d6543e11ec706687c210360e4931fd43a',
    \   'Author: Foo Bar <baz@qux>',
    \   'Date:   Wed Jan 18 18:00:53 2012 +0900',
    \   '',
    \   '    Create a dummy commit to test vim-gf-diff',
    \   '',
    \   'diff --git a/autoload/gf/diff.vim.orig b/autoload/gf/diff.vim',
    \   'index 469fdb3..b135316 100644',
    \   '--- a/autoload/gf/diff.vim.orig',
    \   '+++ b/autoload/gf/diff.vim',
    \   '@@ -21,7 +22,7 @@',
    \   ' "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.',
    \   ' "',
    \   ' " Interface',
    \   '-function! gf#diff#go_to_hunk(type)',
    \   '+function! gf#diff#go(type)',
    \   '   let d = gf#diff#investigate_the_hunk_under_the_cursor()',
    \   '   if d is 0',
    \   '     echomsg ''There is no diff hunk to jump.''',
    \   '@@ -113,7 +114,7 @@ function! gf#diff#investigate_the_hunk_under_the_cursor()',
    \   '       return 0',
    \   '     endif',
    \   '     let [d.from_path, d.to_path] = xs',
    \   '+  call setpos(''.'', original_position)',
    \   '-  call setpos(original_position)',
    \   ' ',
    \   '   return d',
    \   ' endfunction',
    \   'diff --git a/test/internal.input b/test/internal.input',
    \   'index 5395371..8ac577f 100644',
    \   '--- a/test/internal.input',
    \   '+++ b/test/internal.input',
    \   '@@ -37,7 +38,9 @@ endfunction',
    \   ' function s:describe__gf_diff_investigate_the_hunk_under_the_cursor()',
    \   '   It should work properly.',
    \   ' ',
    \   '+  tabnew',
    \   '+    j',
    \   '-  " FIXME: NWY',
    \   '+  tabclose!',
    \   ' endfunction',
    \   ' ',
    \   ' ',
    \ ]

    call setline(1, text)

    normal! 12gg
    let pos = getpos('.')
    let d = gf#diff#investigate_the_hunk_under_the_cursor()
    Expect getpos('.') == pos
    Expect type(d) == type({})
    Expect d.from_first_lineno == 21
    Expect d.to_first_lineno == 22
    Expect d.firstly_deleted_offset == 3
    Expect d.firstly_inserted_offset == 3
    Expect d.from_path ==# 'autoload/gf/diff.vim.orig'
    Expect d.to_path ==# 'autoload/gf/diff.vim'
    unlet d

    normal! 20gg
    let pos = getpos('.')
    let d = gf#diff#investigate_the_hunk_under_the_cursor()
    Expect getpos('.') == pos
    Expect type(d) == type({})
    Expect d.from_first_lineno == 113
    Expect d.to_first_lineno == 114
    Expect d.firstly_deleted_offset == 3
    Expect d.firstly_inserted_offset == 3
    Expect d.from_path ==# 'autoload/gf/diff.vim.orig'
    Expect d.to_path ==# 'autoload/gf/diff.vim'
    unlet d

    normal! 41gg
    let pos = getpos('.')
    let d = gf#diff#investigate_the_hunk_under_the_cursor()
    Expect getpos('.') == pos
    Expect type(d) == type({})
    Expect d.from_first_lineno == 37
    Expect d.to_first_lineno == 38
    Expect d.firstly_deleted_offset == 3
    Expect d.firstly_inserted_offset == 3
    Expect d.from_path ==# 'test/internal.input'
    Expect d.to_path ==# 'test/internal.input'
    unlet d

    normal! 9gg
    let pos = getpos('.')
    let d = gf#diff#investigate_the_hunk_under_the_cursor()
    Expect getpos('.') == pos
    Expect type(d) == type({})
    Expect d.from_first_lineno == 21
    Expect d.to_first_lineno == 22
    Expect d.firstly_deleted_offset == 3
    Expect d.firstly_inserted_offset == 3
    Expect d.from_path ==# 'autoload/gf/diff.vim.orig'
    Expect d.to_path ==# 'autoload/gf/diff.vim'
    unlet d

    normal! 6gg
    let pos = getpos('.')
    let d = gf#diff#investigate_the_hunk_under_the_cursor()
    Expect getpos('.') == pos
    Expect d is 0
    unlet d
  end
end

describe 'gf#diff#calculate_better_lineno'
  it 'works'
    let f = {}
    function! f.c(type, flineno, tlineno, doffset, ioffset)
      return gf#diff#calculate_better_lineno(
      \   a:type,
      \   {
      \     'from_first_lineno': a:flineno,
      \     'to_first_lineno': a:tlineno,
      \     'firstly_deleted_offset': a:doffset,
      \     'firstly_inserted_offset': a:ioffset,
      \   }
      \ )
    endfunction

    Expect f.c('to', 100, 200, -1, -1) == 200
    Expect f.c('to', 100, 200, 3, -1) == 203
    Expect f.c('to', 100, 200, -1, 4) == 204
    Expect f.c('to', 100, 200, 3, 4) == 203
    Expect f.c('from', 100, 200, -1, -1) == 100
    Expect f.c('from', 100, 200, 3, -1) == 103
    Expect f.c('from', 100, 200, -1, 4) == 104
    Expect f.c('from', 100, 200, 3, 4) == 103
  end
end
