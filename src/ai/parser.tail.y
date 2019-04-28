
%%


int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

//void yyerror(const char* s) {
void yyerror (YYLTYPE *locp, char const *msg)
{
	//fprintf(stderr, "Parse error: %s at line \n", s);
	fprintf(stderr, "Parse error: %s at line %d\n", msg, locp->last_line);
	exit(1);
}
