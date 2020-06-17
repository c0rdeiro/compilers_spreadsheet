
projeto: lex.yy.o y.tab.o
	gcc -o projeto lex.yy.o y.tab.o

lex.yy.c: projeto.lex
	flex projeto.lex
	
y.tab.c: projeto.yacc
	byacc -d projeto.yacc
	
lex.yy.o: lex.yy.c y.tab.c
	gcc -c lex.yy.c
	
y.tab.o: y.tab.c
	gcc -c y.tab.c
	
	
