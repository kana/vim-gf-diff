runtime! plugin/gf/user.vim
runtime! plugin/gf/diff.vim

describe 'gf'
  before
    tabnew
  end

  after
    %bwipeout!
  end

  it 'works on git diff'
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

    split
      normal! 12gg
      let diff_bufnr = bufnr('')
      let d = gf#diff#investigate_the_hunk_under_the_cursor()
      silent execute 'normal' 'gf'
      Expect bufnr('') != diff_bufnr
      Expect bufname('') ==# d.to_path
      Expect line('.') == gf#diff#calculate_better_lineno('to', d)
      Expect line('.') == 25
    close

    split
      normal! 9gg
      let diff_pos = getpos('.')
      silent execute 'normal' 'gf'
      Expect bufnr('') != diff_bufnr
      Expect bufname('') ==# d.to_path
      Expect line('.') == gf#diff#calculate_better_lineno('to', d)
      Expect line('.') == 25
    close

    split
      normal! 6gg
      let diff_pos = getpos('.')
      silent execute 'normal' 'gf'
      Expect getpos('.') == diff_pos
    close
  end
end
