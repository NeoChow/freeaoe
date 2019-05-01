
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
