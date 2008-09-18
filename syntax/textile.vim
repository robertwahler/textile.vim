"
"   You will have to restart vim for this to take effect.  In any case
"   it is a good idea to read ":he new-filetype" so that you know what
"   is going on, and why the above lines work.
"
"   Written originally by Dominic Mitchell, Jan 2006.
"   happygiraffe.net
"
"   Modified by Aaron Bieber, May 2007.
"   blog.aaronbieber.com
"
"   Modified by Tim Harper, July 2008 - current
"   tim.theenchanter.com
" @(#) $Id$

let textile_css=1
let textile_html=1

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

if !exists("main_syntax")
  let main_syntax = 'textile'
endif

" CSS highlighting.
if exists("textile_css")
    syn include @cssTop syntax/css.vim 
    syn cluster cssTop remove=cssTagName
    syn sync clear
    unlet b:current_syntax
endif

" HTML highlighting.
if exists("textile_html")
    syn include @htmlTop syntax/html.vim 
    syn sync clear
    unlet b:current_syntax
endif

syn region textileHtml start="<\s*[-a-zA-Z0-9]\+" end="</\s*[-a-zA-Z0-9]\+>" end="/>" keepend contains=@htmlTop

syn region textileCode start="<code>"ms=s+6 end="</code>" contains=@NoSpell
syn region textilePreformatted start="<pre\>" end="</pre>" keepend contains=textileCode,@htmlTop

" syn cluster textileTop contains=@textileCss
syn region textileCss start="{" end="}" keepend contains=@cssTop contained
syn region textileParenthisis start="(" end=")" contained contains=@textileCssClass,@textileCssId
syn region textileLanguage start="\[" end="\]" contained

" Textile commands like "h1" are case sensitive, AFAIK.
syn case match

" Textile syntax: <http://textism.com/tools/textile/>

syn region textileLinkTitle start="("       end=")" contained keepend
syn region textileLinkText matchgroup=String start=+"+ end=+"+ contained keepend contains=textileLinkTitle
syn region textileLinkHref  start=+:+ms=s+1 end="$" contained contains=@NoSpell

" Inline elements.
syn match txtEmphasis    /_[^_]\+_/     transparent
syn match txtBold        /\*[^*]\+\*/
syn match txtCite        /??.\+??/
syn match txtDeleted     /-[^-]\+-/
syn match txtInserted    /+[^+]\++/
syn match txtSuper       /\^[^^]\+\^/
syn match txtSub         /\~[^~]\+\~/
syn match txtSpan        /%[^%]\+%/     contains=textileCss
syn match txtFootnoteRef /\[[0-9]\+]/
syn match txtCode        /@[^@]\+@/
syn match txtImage       /![^!]\+!/

" Everything after the first colon is from RFC 2396, with extra
" backslashes to keep vim happy...  Original:
" ^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
"
" Revised the pattern to exclude spaces from the URL portion of the
" pattern. Aaron Bieber, 2007.
syn match txtLink /"[^"]\+":\(\([^:\/?# ]\+\):\)\?\(\/\/\([^\/?# ]*\)\)\?\([^?# ]*\)\(?\([^# ]*\)\)\?\(#\([^ ]*\)\)\?/ contains=textileLinkText,textileLinkHref

syn cluster txtInlineElement contains=txtEmphasis,txtBold,txtCite,txtDeleted,txtInserted,txtSuper,txtSub,txtSpan,txtLink

" Block elements.
syn region textileH1 start="^h1" end="$" contains=textileTop,textileCss
syn region textileH2 start="^h2" end="$" contains=textileTop,textileCss,@txtInlineElement

" syn match txtHeader         /^h1\(([^)]*)\)\{0,1\}\({[^}]*}\)\{0,1\}\. .\+/
" syn match txtHeader2        /^h2\(([^)]*)\)\{0,1\}\({[^}]*}\)\{0,1\}\. .\+/
syn match txtHeader3        /^h[3-6]\(([^)]*)\)\{0,1\}\({[^}]*}\)\{0,1\}\..\+/ contains=@txtInlineElement
syn match txtBlockquote     /^bq\(\[[^\]]*\]\)\{0,1\}\./
syn match txtFootnoteDef    /^fn[0-9]\+\./
syn match txtListBullet     /\v^ {0,1}\*+ /
syn match txtListBullet2    /\v^ {0,1}(\*\*)+ /
syn match txtListNumber     /\v^ {0,1}#+(\{[^\}]*\}){0,1} /                contains=textileCss
syn match txtListNumber2    /\v^ {0,1}(##)+(\{[^\}]*\}){0,1} /             contains=textileCss
syn match txtTable          /^table\({[^}]*}\)\{0,1\}\./                   contains=@NoSpell,textileCss
syn match txtParagraph      /^p\(([^)]*)\)\{0,1\}\({[^}]*}\)\{0,1\}\./     contains=@NoSpell,textileCss

syn cluster txtBlockElement contains=txtHeader,txtBlockElement,txtFootnoteDef,txtListBullet,txtListNumber

if version >= 508 || !exists("did_txt_syn_inits")
    if version < 508
        let did_txt_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink textileH1 Title
    HiLink textileH2 Question
    HiLink textileCode Constant

    HiLink txtHeader Title
    HiLink txtHeader2 Question
    HiLink txtHeader3 Statement
    HiLink txtBlockquote Comment
    HiLink txtListBullet Operator
    HiLink txtListBullet2 Constant
    HiLink txtListNumber Operator
    HiLink txtListNumber2 Constant

    "HiLink txtLink String
    HiLink textileLinkText Underlined
    HiLink textileLinkHref String
    HiLink textileLinkTitle Comment

    HiLink txtCode Identifier
    HiLink txtImage Constant
    HiLink txtParagraph Title
    HiLink txtTable Title

    "hi txtEmphasis gui=italic
    hi def txtEmphasis term=underline cterm=underline gui=italic
    hi def txtBold term=bold cterm=bold gui=bold

    delcommand HiLink
endif

" vim: set ai et sw=4 nowrap :
