% --------------------------------------------------------------------------
% the CHEMFORMULA package
%
%   typeset chemical compounds and reactions
%
% --------------------------------------------------------------------------
% Clemens Niederberger
% --------------------------------------------------------------------------
% https://github.com/cgnieder/chemformula/
% contact@mychemistry.eu
% --------------------------------------------------------------------------
% If you have any ideas, questions, suggestions or bugs to report, please
% feel free to contact me.
% --------------------------------------------------------------------------
% Copyright 2011--2020 Clemens Niederberger
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is Clemens Niederberger.
% --------------------------------------------------------------------------
\ProvidesClass{chemformula-manual}[2020/02/01]

\LoadClass[load-preamble,add-index]{cnltx-doc}
\RequirePackage{imakeidx}
\RequirePackage[utf8]{inputenc}

\RequirePackage{chemformula}
\RequirePackage{chemmacros}

\setcnltx{
  package  = {chemformula},
  info     = {typeset chemical compounds and reactions} ,
  url      = http://www.mychemistry.eu/forums/forum/chemformula/ ,
  authors  = Clemens Niederberger ,
  email    = contact@mychemistry.eu ,
  abstract = {%
    \centering
    \includegraphics{chemmacros-logo.pdf}
    \par
  } ,
  add-cmds = {
    bond,
    ce, ch, charrow, chcpd, chemformula@bondlength, chemsetup, chlewis,
      chname,
    DeclareChemAdditionSymbol, DeclareChemArrow, DeclareChemBond,
      DeclareChemBondAlias, DeclareChemCompoundProperty, DeclareChemSymbol,
    mch,
    NewChemAdditionSymbol, NewChemArrow, NewChemBond, NewChemBondAlias,
      NewChemCompoundProperty, NewChemSymbol,
    ox, OX,
    pch,
    redox, RemoveChemCompoundProperty, RenewChemAdditionSymbol,
      RenewChemArrow, RenewChemBond, RenewChemCompoundProperty,
      RenewChemSymbol,
    setchemformula, ShowChemArrow, ShowChemBond
  } ,
  add-silent-cmds = {
    addplot,
    chemfig,
    DeclareInstance, draw,
    sample, setchemfig, sfrac,
    usetikzlibrary
  } ,
  index-setup = { othercode=\footnotesize, level=\section } ,
  makeindex-setup = {  columns=3, columnsep=1em }
}

\RequirePackage{chemfig,booktabs,cancel,varioref}
\RequirePackage[version=4]{mhchem}

\def\libertine@figurestyle{LF}
\RequirePackage{amsmath}
\undef\lvert \undef\lVert
\undef\rvert \undef\rVert
\RequirePackage[libertine]{newtxmath}
\def\libertine@figurestyle{OsF}

\RequirePackage{fontawesome}
\RequirePackage{datetime2}
\DTMsetup{useregional=numeric,datesep=/}
\newrobustcmd*\chemformula@add@version[2]{%
  \csdef{chemformula@ver@#2}{%
    \DTMdate{#1}%
    \csgdef{chemformula@ver@#2used}{}%
    \csdef{chemformula@ver@#2}{\DTMdate{#1}}%
  }%
}

\newrobustcmd*\chemformula@date[1]{%
  \ifcsdef{chemformula@ver@#1used}{}{ (\csuse{chemformula@ver@#1})}}
\newrobustcmd*\chemformula@ifnew[1]{\ifcsstring{c_chemformula_version_tl}{#1}}
\newrobustcmd*\chemformula@NEW{\faStarO\ New}

\renewrobustcmd*\sinceversion[1]{%
  \chemformula@ifnew{#1}%
    {\cnltx@version@note{\textcolor{red}{\chemformula@NEW}}}%
    {\cnltx@version@note{\GetTranslation{cnltx-introduced}~#1\chemformula@date{#1}}}%
}
\renewrobustcmd*\changedversion[1]{%
  \cnltx@version@note{\GetTranslation{cnltx-changed}~#1\chemformula@date{#1}}%
}

\newnote*\sincechanged[2]{%
  \GetTranslation{cnltx-introduced}~#1\chemformula@date{#1},
  changed with version~#2\chemformula@date{#2}\chemformula@ifnew{#2}{ \chemformula@NEW}{}%
}

\RenewDocumentEnvironment{commands}{}
  {%
    \cnltx@set@catcode_{12}%
    \let\command\cnltx@command
    \cnltxlist
  }
  {\endcnltxlist}
  
\RequirePackage{tcolorbox,xsimverb}
\tcbuselibrary{skins,breakable}
\tcbset{enhanced,enhanced jigsaw}

\newtcolorbox{bewareofthedog}{
  colback  = white ,
  colframe = red ,
  underlay={%
    \path[draw=none]
      (interior.south west)
      rectangle node[red]{\Huge\bfseries !}
      ([xshift=-4mm]interior.north west);
    }%
}

\newtcolorbox{cnltxcode}[1][]{
  boxrule = 1pt ,
  colback = cnltxbg ,
  colframe = cnltx ,
  arc = 5pt ,
  beforeafter skip = .5\baselineskip ,%
  #1%
}

\newcommand*\chemformula@readoptions[1]{%
  \catcode`\^^M=13
  \chemformula@read@options{#1}%
}

\begingroup
\catcode`\^^M=13
\gdef\chemformula@read@options#1#2^^M{%
  \ifblank{#2}{}{\chemformula@read@options@#2}%
  #1%
  \XSIMfilewritestart*{\jobname.tmp}%
}%
\endgroup

\def\chemformula@read@options@[#1]{\pgfqkeys{/cnltx}{#1}}

\RenewDocumentEnvironment{sourcecode}{}
  {%
    \chemformula@readoptions{%
      \setlength\cnltx@sidebysidewidth
        {\dimexpr .45\columnwidth -\lst@xleftmargin -\lst@xrightmargin\relax}%
      \expanded{%
        \noexpand\lstset{
          style=cnltx,
          \ifboolexpe{ bool {cnltx@sidebyside} and not bool {cnltx@codeonly} }
            {linewidth=\cnltx@sidebysidewidth,}{}%
          \expandonce\cnltx@local@listings@options
        }%
      }%
      \XSIMgobblechars{2}%
    }%
  }
  {%
    \XSIMfilewritestop
    \cnltxcode[breakable]%
    \lstinputlisting[style=cnltx]{\jobname.tmp}%
    \endcnltxcode
  }

\RenewDocumentEnvironment{example}{}
  {%
    \chemformula@readoptions{%
      \setlength\cnltx@sidebysidewidth
        {\dimexpr .45\columnwidth -\lst@xleftmargin -\lst@xrightmargin\relax}%
      \expanded{%
        \noexpand\lstset{
          style=cnltx,
          \ifboolexpe{ bool {cnltx@sidebyside} and not bool {cnltx@codeonly} }
            {linewidth=\cnltx@sidebysidewidth,}{}%
          \expandonce\cnltx@local@listings@options
        }%
      }%
      \XSIMgobblechars{2}%
    }%
  }
  {%
    \XSIMfilewritestop
    \catcode`\^^M=5
    \ifbool{cnltx@sidebyside}
      {%
        \cnltxcode
        \noindent
        \minipage[c]{\cnltx@sidebysidewidth}%
          \cnltx@pre@source@hook
          \lstinputlisting[style=cnltx] {\jobname.tmp}%
          \cnltx@after@source@hook
        \endminipage\hfill
        \minipage[c]{\cnltx@sidebysidewidth}%
          \cnltx@pre@example@hook
          \input {\jobname.tmp}%
          \cnltx@after@example@hook
        \endminipage
      }
      {%
        \cnltxcode[breakable]%
        \cnltx@pre@source@hook
        \lstinputlisting{\jobname.tmp}%
        \cnltx@after@source@hook
        \tcblower
        \cnltx@pre@example@hook
        \input {\jobname.tmp}%
        \cnltx@after@example@hook
      }%
    \endcnltxcode
  }

\RequirePackage[
  backend=biber,
  style=cnltx,
  sortlocale=en_US,
  indexing=cite]{biblatex}
\RequirePackage{csquotes,varioref}
\defbibheading{bibliography}{\section{References}}

\RequirePackage[biblatex]{embrac}[2012/06/29]
\ChangeEmph{[}[,.02em]{]}[.055em,-.08em]
\ChangeEmph{(}[-.01em,.04em]{)}[.04em,-.05em]

\chemformula@add@version{2012-01-28}{3.0}
\chemformula@add@version{2012-01-30}{3.0a}
\chemformula@add@version{2012-02-03}{3.0b}
\chemformula@add@version{2012-02-05}{3.0c}
\chemformula@add@version{2012-02-10}{3.0d}
\chemformula@add@version{2012-02-19}{3.1}
\chemformula@add@version{2012-02-26}{3.1a}
\chemformula@add@version{2012-03-03}{3.1b}
\chemformula@add@version{2012-03-14}{3.1c}
\chemformula@add@version{2012-03-20}{3.2}
\chemformula@add@version{2012-05-07}{3.3}
\chemformula@add@version{2012-05-13}{3.3a}
\chemformula@add@version{2012-05-18}{3.3b}
\chemformula@add@version{2012-05-18}{3.3c}
\chemformula@add@version{2012-07-24}{3.3d}
\chemformula@add@version{2012-08-21}{3.3e}
\chemformula@add@version{2012-09-11}{3.4}
\chemformula@add@version{2012-10-03}{3.4a}
\chemformula@add@version{2013-01-04}{3.4b}
\chemformula@add@version{2013-01-28}{3.5}
\chemformula@add@version{2013-02-19}{3.5a}
\chemformula@add@version{2013-02-26}{3.6}
\chemformula@add@version{2013-02-27}{3.6a}
\chemformula@add@version{2013-04-19}{3.6b}
\chemformula@add@version{2013-07-06}{4.0}
\chemformula@add@version{2013-07-26}{4.0a}
\chemformula@add@version{2013-08-24}{4.1}
\chemformula@add@version{2013-10-24}{4.2}
\chemformula@add@version{2013-11-04}{4.2a}
\chemformula@add@version{2014-01-24}{4.3}
\chemformula@add@version{2014-01-29}{4.4}
\chemformula@add@version{2014-04-07}{4.5}
\chemformula@add@version{2014-06-30}{4.6}
\chemformula@add@version{2014-08-04}{4.7}
\chemformula@add@version{2014-08-08}{4.8}
\chemformula@add@version{2014-10-07}{4.9}
\chemformula@add@version{2015-03-16}{4.10}
\chemformula@add@version{2015-04-03}{4.10a}
\chemformula@add@version{2015-06-30}{4.11}
\chemformula@add@version{2015-08-12}{4.12}
\chemformula@add@version{2015-08-29}{4.12a}
\chemformula@add@version{2015-09-08}{4.12b}
\chemformula@add@version{2015-01-01}{4.13}
\chemformula@add@version{2015-10-21}{4.14}
\chemformula@add@version{2016-01-07}{4.14a}
\chemformula@add@version{2016-05-03}{4.14b}
\chemformula@add@version{2016-05-11}{4.15}
\chemformula@add@version{2016-06-08}{4.15a}
\chemformula@add@version{2016-06-08}{4.15b}
\chemformula@add@version{2016-08-21}{4.15c}
\chemformula@add@version{2017-02-02}{4.15d}
\chemformula@add@version{2017-03-23}{4.15e}
\chemformula@add@version{2019-09-23}{4.15f}
\chemformula@add@version{2019-09-27}{4.15g}
\chemformula@add@version{2019-10-13}{4.15h}
\chemformula@add@version{2020-02-01}{4.15i}

\endinput
