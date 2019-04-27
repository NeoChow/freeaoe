%option case-insensitive
%option noyywrap
%option yylineno
%option c++
%option yyclass="ai::ScriptTokenizer"
%{
    #include "ScriptLoader.h"
    #include "ScriptTokenizer.h"
    #include "parser.tab.hh"
    #include "location.hh"

    static ai::location loc;

    #define YY_USER_ACTION loc.step(); loc.columns(yyleng);

    #undef  YY_DECL
    #define YY_DECL ai::ScriptParser::symbol_type ai::ScriptTokenizer::yylex(ai::ScriptLoader &driver)

    #define yyterminate() return ai::ScriptParser::make_ScriptEnd(loc);

    #define RET_TOKEN(token_name) return ai::ScriptParser::symbol_type(ai::ScriptParser::token::token_name, loc);
    #define RET_STRING(token_name) return ai::ScriptParser::symbol_type(ai::ScriptParser::token::token_name, yytext, loc);
    #define RET_INT(token_name) return ai::ScriptParser::symbol_type(ai::ScriptParser::token::token_name, atoi(yytext), loc); 

%}



symbolname  [a-zA-Z]+[a-zA-Z-]*
string      \"[^"\r\n]*\"
number      [0-9]+
comment     ;.*
blank   [ \t]+

%%

{comment}

{blank}

"("                 RET_TOKEN(OpenParen)
")"                 RET_TOKEN(CloseParen)
"defrule"           RET_TOKEN(RuleStart)
"=>"                RET_TOKEN(ConditionActionSeparator)

"not"               RET_TOKEN(Not)
"or"                RET_TOKEN(Or)

"<"                 RET_TOKEN(LessThan)
"less-than"         RET_TOKEN(LessThan)

"<="                RET_TOKEN(LessOrEqual)
"less-or-equal"     RET_TOKEN(LessOrEqual)

">"                 RET_TOKEN(GreaterThan)
"greater-than"      RET_TOKEN(GreaterThan)

">="                RET_TOKEN(GreaterOrEqual)
"greater-or-equal"  RET_TOKEN(GreaterOrEqual)

"=="                RET_TOKEN(Equal)
"equal"             RET_TOKEN(Equal)

"#load-if-defined"  RET_TOKEN(LoadIfDefined)
"#else"             RET_TOKEN(Else)
"#end-if"           RET_TOKEN(EndIf)

[\r\n]+

{symbolname}        RET_STRING(SymbolName)
{string}            RET_STRING(String)
{number}            RET_INT(Number)

%%
