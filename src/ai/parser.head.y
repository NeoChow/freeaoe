%define parse.error verbose
%define api.pure full
%locations

%{

#include <string>
#include "common.h"
#include "gen/enums.h"


extern int yyparse();
extern FILE* yyin;
//extern YYLTYPE yylloc;


//void yyerror(const char* s);
void yyerror (YYLTYPE *locp, char const *msg);

#define YYPARSE_PARAM aiRule

union YYSTYPE;
// extern int yylex(union YYSTYPE *);

int yylex(YYSTYPE *lvalp, YYLTYPE *llocp);

%}


%union {
	int number;
	char *string;
    ParameterType type;
}

%destructor { delete $$; $$ = nullptr; } String SymbolName;

%token<number> Number
%token<string> String
%token<string> SymbolName

%token OpenParen CloseParen
%token RuleStart ConditionActionSeparator

%token FnSetStrategicNumber

%token Not Or

%token LoadIfDefined Else EndIf

%token Space NewLine

%start aiscript
