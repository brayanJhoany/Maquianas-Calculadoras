%{
/*
 * Autor:  Rodrigo Paredes Moraleda
 * correo: raparede@dcc.uchile.cl
 */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
int tabla[3];
void setear_valor(char, int);
int buscar_valor(char);

/*
 * Vamos a usar una gramatica muy simple que permite calcular sumas,
 * maneja tres variables y solo numeros de un digito (entre 0 y 9):
 *
 * lineas  -> linea lineas
 * linea   -> expr | var = expr
 * expr    -> expr + expr | variable | numero
 * numero  -> 0 | 1 | ... | 9
 * variable -> a | b | c
 *
 * se compila con
 * bison ejemplo.y # esto sirve para transformar la GLC en codigo C
 * gcc ejemplo.tab.c -o ejemplo # esto compila el codigo C
 */
%}

%%
lineas	: linea lineas
	|
	;
linea	: expr '\n'{               printf("%d\n-> ", $1); }
	| variable '==' expr '\n'   { setear_valor($1, $3);
                                     printf("%c asignado con %d\n-> ", $1, $3); }
        | '\n'                     { printf("-> "); }
        | 'F' 'I' 'N'              { printf("fin de la minicalculadora\n"); exit(0); }
	;
expr	: expr '+' expr	           { $$ = $1 + $3; }
	| variable                 { $$ = buscar_valor($1); }
        | digito                   { $$ = $1; }
	;
digito	: '0'                      { $$ = 0; }
	| '1'                      { $$ = 1; }
	| '2'                      { $$ = 2; }
	| '3'                      { $$ = 3; }
	| '4'                      { $$ = 4; }
	| '5'                      { $$ = 5; }
	| '6'                      { $$ = 6; }
	| '7'                      { $$ = 7; }
	| '8'                      { $$ = 8; }
	| '9'                      { $$ = 9; }
	;
variable: 'a'                      { $$ = 'a'; }
	| 'b'                      { $$ = 'b'; }
	| 'c'                      { $$ = 'c'; }
	;
%%
yylex() {
        int c;
        while ( (c=getchar()) == ' ') ;
        return(c);
}

yyerror() {
	printf("Error sintactico\n");
}

main() {
	printf ("-> ");
	yyparse();
}

void setear_valor(char c, int valor) {
	tabla[c - 'a'] = valor;
}

int buscar_valor(char c) {
	return(tabla[c - 'a']);
}
