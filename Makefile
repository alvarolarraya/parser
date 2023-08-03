all:
	@bison -v -d parser.y
	@flex scanner.l
	@gcc -c lex.yy.c
	@gcc parser.tab.c lex.yy.o TablaSimbolos.c TablaCuadruplas.c -ll -lm
clean:
	@rm lex.yy.c
	@rm parser.output
	@rm lex.yy.o
	@rm parser.tab.c
	@rm parser.tab.h
	@rm a.out
	@rm codigoTresDirecciones.txt