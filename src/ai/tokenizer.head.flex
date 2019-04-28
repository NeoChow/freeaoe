%option case-insensitive
%option noyywrap
%option nointeractive
%option nostdinit
%option nodefault
%option yylineno
%option bison-bridge

%{
#include <stdio.h>
#include "common.h"
#include "grammar.gen.tab.h"

/*[ \t\f]+            { return Space; }*/

#define YY_DECL  int yylex(union YYSTYPE *yylval_param, YYLTYPE *llocp)



//size_t offset;
//YYLTYPE yylloc;
//
#define YY_USER_ACTION         \
  llocp->offset += yyleng;            \
  llocp->last_line = yylineno; \
  llocp->last_column = llocp->offset;

%}

symbolname      [a-zA-Z]+[a-zA-Z-]*
string          \"[^"\r\n]*\"
number          [0-9]+
comment         ;.*
blank           [ \t]+

%%

{comment}
{blank}

