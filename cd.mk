a.out : y.tab.c lex.yy.c 
	gcc y.tab.c lex.yy.c -ll -ly
y.tab.c : proj1.y 
	yacc proj1.y -d
lex.yy.c : proj1.l
	lex proj1.l 
