%skeleton "lalr1.cc"
%require  "3.0"

%defines
%define api.namespace { ai }
%define api.parser.class {ScriptParser}
%define api.value.type variant
%define api.token.constructor
%define parse.assert true
%define parse.error verbose
%locations


%param {ai::ScriptLoader &driver}
%parse-param {ai::ScriptTokenizer &scanner}

%code requires {

    namespace ai {
        class ScriptTokenizer;
        class ScriptLoader;
    }

    #ifndef YYDEBUG
        #define YYDEBUG 1
    #endif

    #define YY_NULLPTR nullptr
}


%{

    #include <cassert>
    #include <iostream>

    #include "ScriptLoader.h"
    #include "ScriptTokenizer.h"

    #include "parser.tab.hh"
    #include "location.hh"

    #undef yylex
    #define yylex scanner.yylex
%}

// %union {
// 	int number;
// 	char *string;
// }

// %destructor { delete $$; $$ = nullptr; } String SymbolName;

%token<int> Number
%token<std::string> String
%token<std::string> SymbolName
%token<std::string> StrategicNumber

%token OpenParen CloseParen
%token RuleStart ConditionActionSeparator

%token FnSetStrategicNumber

%token LessThan LessOrEqual GreaterThan GreaterOrEqual Equal Not Or

%token LoadIfDefined Else EndIf

%token Space NewLine

%token ScriptEnd 0

%start aiscript

%include "gen/tokens.y"

%%

aiscript:
    /* Empty */
    | rules ScriptEnd { printf("got script\n"); }
;

rules:
    rule { printf("got single rule\n"); }
    | rule rules { printf("got multiple rules\n"); }

rule:
    OpenParen RuleStart conditions ConditionActionSeparator actions CloseParen { printf("got rule\n====\n\n"); }

conditions:
    condition {  printf("got single condition\n"); }
    | condition conditions {  printf("got multiple conditions\n"); }

condition:
    OpenParen Not condition CloseParen {  printf("got negated condition\n"); }
    | OpenParen Or conditions CloseParen {  printf("got multiple or conditions\n"); }
    | OpenParen SymbolName CloseParen {  printf("got condition with symbol '%s'\n", $2.c_str()); }
    | OpenParen SymbolName Number CloseParen {  printf("got condition with symbol '%s' and number %d\n", $2.c_str(), $3.c_str()); }
    | OpenParen SymbolName Number Number CloseParen {  printf("got condition with symbol '%s' and numbers %d %d\n", $2.c_str(), $3.c_str(), $4.c_str()); }
    | OpenParen SymbolName SymbolName CloseParen {  printf("got condition with two symbols '%s' %s\n", $2.c_str(), $3.c_str()); }
    | OpenParen SymbolName SymbolName SymbolName CloseParen {  printf("got condition with three symbols %s %s %s\n", $2.c_str(), $3.c_str(), $4.c_str()); }
    | OpenParen SymbolName comparison Number CloseParen {  printf("got condition with comparison %s %d\n", $2.c_str(), $4.c_str()); }
    | OpenParen SymbolName comparison SymbolName CloseParen {  printf("got condition with comparison %s %s\n", $2.c_str(), $4.c_str()); }
    | OpenParen SymbolName SymbolName comparison SymbolName CloseParen {  printf("got condition with comparison %s %s %s\n", $2.c_str(), $3.c_str(), $5.c_str()); }
    | OpenParen SymbolName SymbolName comparison Number CloseParen {  printf("got condition with comparison %s %s %d\n", $2.c_str(), $3.c_str(), $5.c_str()); }
    | OpenParen SymbolName SymbolName SymbolName comparison Number CloseParen {  printf("got condition with comparison %s %s %s %d\n", $2.c_str(), $3.c_str(), $4.c_str(), $6.c_str()); }


comparison:
    LessThan {  printf("got lessthan\n"); }
    | LessOrEqual {  printf("got lessorequal\n"); }
    | GreaterThan {  printf("got greaterthan\n"); }
    | GreaterOrEqual {  printf("got greaterorequal\n"); }
    | Equal {  printf("got equals\n"); }

actions:
    action {  printf("got single action\n"); }
    | action  actions {  printf("got multiple actions\n"); }

    OpenParen SymbolName CloseParen { printf("got action %s without arguments\n", $2.c_str()); }
    | OpenParen SymbolName String CloseParen {  printf("got action %s with string %s\n", $2.c_str(), $3.c_str()); }
    | OpenParen FnSetStrategicNumber StrategicNumber Number CloseParen {  printf("got action  with symbol %s and number %d\n",  $3.c_str(), $4.c_str()); }
    | OpenParen SymbolName SymbolName Number CloseParen {  printf("got action %s with symbol %s and number %d\n", $2.c_str(), $3.c_str(), $4.c_str()); }
    | OpenParen SymbolName SymbolName CloseParen {  printf("got action %s with symbol %s\n", $2.c_str(), $3.c_str()); }
    | OpenParen SymbolName Number CloseParen {  printf("got action %s with number %d\n", $2.c_str(), $3.c_str()); }
    | OpenParen SymbolName Number Number CloseParen {  printf("got action %s with numbers %d %d\n", $2.c_str(), $3.c_str(), $4.c_str()); }


%%

int main() {
       ai::ScriptLoader parser;
       return parser.parse(std::cin, std::cout);
}

void ai::ScriptParser::error(const location_type &loc, const std::string& message) {
    std::cerr << "parser error: " << message << " at " << loc.begin.line << std::endl;
}
