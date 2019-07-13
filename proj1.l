%{
    #include "y.tab.h"
    #include "symtab.h"
    #include<malloc.h>
    #include<string.h>
    int lineNum=0;
    int single=0;
    int multi=0;
    int temp_2;
%}
%option yylineno
singlecmt "//".*
multi \/\*(.*\n)*.*\*\/
%%
"var" 						{return T_VAR;}
"for" 						{return T_FOR;}
"while" 					{return T_WHILE;}
"BREAK"			{return T_BRK;}
"break" 		{return T_BRK;}
"CONTINUE"		{return T_CNT;}
"continue" 		{return T_CNT;}
"TRUE"			{yylval=1; return T_TRUE;}
"true"			{yylval=1; return T_TRUE;}
"FALSE"			{yylval=0; return T_FALSE;}
"false"			{yylval=0; return T_FALSE;}

[a-zA-Z][_a-zA-Z0-9]* 	{printf("id has been detected\n"); free(name); yylval=*yytext; name=(char*)malloc(sizeof(char*)*strlen(yytext)); strcpy(name,yytext); printf("id is:%s\n",name); return T_ID;}//yylval=*yytext; 

[\"a-zA-Z][a-zA-Z0-9]*[\"] 	{yylval=*yytext; free(str); str=(char*)malloc(sizeof(char*)*strlen(yytext)-2); strncpy(str,yytext+1,strlen(yytext)-2); return T_STRING;}
[0-9]+ 						{yylval=atoi(yytext); return T_INT;}
[0-9]+[\.][0-9]+ 			{yylval=atoi(yytext); return T_FLOAT;}
"("		{return T_OBR;}
")"		{return T_CBR;}
"["		{return T_SOBR;}
"]"		{return T_SCBR;}
"{"		{return T_FOBR;}
"}"		{return T_FCBR;}
"++"	{return T_UADD;}
"--"	{return T_USUB;}
"*"		{return T_MUL;}
"/"		{return T_DIV;}
"+"		{return T_ADD;}
"-"		{return T_SUB;}

"!"		{return T_NT;}
"~"		{return T_BTNT;}


"%"		{return T_MOD;}

">>" 	{return T_RS;}
"<<" 	{return T_LS;}
">" 	{return T_GT;}
">=" 	{return T_GTE;}
"<" 	{return T_LT;}
"<=" 	{return T_LTE;}
"==" 	{return T_CMP;}
"!=" 	{return T_NEQ;}
"===" 	{return T_SCMP;}
"!==" 	{return T_SNEQ;}
"&"		{return T_AND;}
"^"  	{return T_XOR;}
"|"		{return T_OR;}
"&&"	{return T_LAND;}
"||"	{return T_LOR;}
"'"	{return T_OPS;}
"\""	{return T_DQT;}	
"="		{return T_EQ;}
"*="	{return T_MULASN;}
"/="	{return T_DIVASN;}
"%="	{return T_MODASN;}
"+="	{return T_ADDASN;}
"-="	{return T_SUBASN;}
","		{return T_CM;}
";"		{return T_SCLN;}
\n {lineNum++;};

{singlecmt} ;
{multi} ;
.|[' ']|[\t] ;
%%


     

int yywrap()
{
return 1;
}


