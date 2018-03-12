%{
	#include <stdio.h>
	#include "zoomjoystrong.h"
	void yyerror(const char* msg);
	int yylex();
%}

%error-verbose
%start zoom

%union { int i; char* str; float f; }

%token INTEGER
%token FLOAT
%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR

%type<i> INTEGER
%type<f> FLOAT
%type<str> END
%type<str> POINT
%type<str> LINE
%type<str> CIRCLE
%type<str> RECTANGLE
%type<str> SET_COLOR

%%

zoom:				statement_list END END_STATEMENT
;

statement_list: 	statement
		|			statement statement_list
;

statement: 			point | line | circle | rectangle | set_color
;

point:				POINT INTEGER INTEGER END_STATEMENT
					{ 
					if($2 < 0 || $2 > 1024 || $3 < 0 || $3 > 768)
						yyerror("Invalid value. You are drawing a point beyond the screen size");
					else
						point( $2, $3 ); }
;

line:				LINE INTEGER INTEGER INTEGER INTEGER END_STATEMENT
					{ 
					if($2 < 0 || $2 > 1024 || $3 < 0 || $3 > 768 
					|| $4 < 0 || $4 > 1024 || $5 < 0 || $5 > 768)
						yyerror("Invalid value. You are drawing a line beyond the screen size");
					else
						line( $2, $3, $4, $5 ); }
;

circle:				CIRCLE INTEGER INTEGER INTEGER END_STATEMENT
					{ 
					if($2 < 0 || $2 > 1024 || $3 < 0 || $3 > 768 
					|| $4 < 0 || $4 > 1024)
						yyerror("Invalid value. You are drawing a circle beyond the screen size");
					else
						circle( $2, $3, $4 ); }
;

rectangle:			RECTANGLE INTEGER INTEGER INTEGER INTEGER END_STATEMENT
					{ 
					if($2 < 0 || $2 > 1024 || $3 < 0 || $3 > 768 
					|| $4 < 0 || $4 > 1024 || $5 < 0 || $5 > 768)
						yyerror("Invalid value. You are drawing a rectangle beyond the screen size");
					else
						rectangle( $2, $3, $4, $5 ); }
;

set_color:			SET_COLOR INTEGER INTEGER INTEGER END_STATEMENT
					{ 
					if ($2 < 0 || $2 > 255 || $3 < 0 || $3 > 255 || $4 < 0 || $4 > 255)
						yyerror("Invalid value. Has to be between 0-255");
					else
						set_color( $2, $3, $4 ); }
;

%%
int main(int argc, char** argv){
	setup();
	yyparse();
	finish();
	return 0;
}

void yyerror(const char* msg){
	fprintf(stderr, "ERROR! %s\n", msg);
}
