%option noyywrap

%{
#include "y.tab.h"
%}

 
%%

[0-9]+\.?[0-9]*		{yylval.dval = atof(yytext); return NUMERO;}

A					{yylval.dval = 0; return NUMERO;}
B					{yylval.dval = 1; return NUMERO;}
C					{yylval.dval = 2; return NUMERO;}
D					{yylval.dval = 3; return NUMERO;}
E					{yylval.dval = 4; return NUMERO;}
F					{yylval.dval = 5; return NUMERO;}
G					{yylval.dval = 6; return NUMERO;}
H					{yylval.dval = 7; return NUMERO;}					
a					return SETA_ESQ;
s					return SETA_BAIXO;
d					return SETA_DIR;
w					return SETA_CIMA;
#[a-zA-Z]+			{yylval.sval = yytext; return TEXTO;}
=SUM 				{yylval.sval = yytext; return SUM;}
=AVG 				{yylval.sval = yytext; return AVG;}
=MAX 				{yylval.sval = yytext; return MAX;}
=MIN 				{yylval.sval = yytext; return MIN;}
ASC					{yylval.sval = yytext; return ASC;}
DESC				{yylval.sval = yytext; return DESC;}
ROUND				return ROUND;
GO					{yylval.sval = yytext; return GO;}
[,;()] 				return yytext[0];
HOME				return HOME;
END					return END;
EXIT				return EXIT;
SAVEEXIT   		 	return SAVEEXIT;
SAVE				return SAVE;
READ				return READ;
[-+*/^]             return yytext[0];
.					;
\n					return yytext[0];
