
"set-strategic-number" { return FnSetStrategicNumber; }
"("                 { return OpenParen; }
")"                 { return CloseParen; }
"defrule"           { return RuleStart; }
"=>"                { return ConditionActionSeparator; }

"not"                 { return Not; }
"or"                 { return Or; }

"<"                 { return RelOpLessThan; }
"less-than"         { return RelOpLessThan; }

"<="                { return RelOpLessOrEqual; }
"less-or-equal"     { return RelOpLessOrEqual; }

">"                 { return RelOpGreaterThan; }
"greater-than"      { return RelOpGreaterThan; }

">="                { return RelOpGreaterOrEqual; }
"greater-or-equal"  { return RelOpGreaterOrEqual; }

"=="                { return RelOpEqual; }
"equal"             { return RelOpEqual; }

"#load-if-defined"  { return LoadIfDefined; }
"#else"             { return Else; }
"#end-if"           { return EndIf; }

[\r\n]+

{symbolname}        { yylval_param->string = strdup(yytext); return SymbolName; }
{string}            { yylval_param->string = strdup(yytext); return String; }
{number}            { yylval_param->number = atoi(yytext); return Number; }

%%
