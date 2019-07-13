%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "symtab.c"

extern FILE *yyin,*yyout;
extern int lineNum;
extern entry_count;
int ErrorRecovered = 0,n=100,tracker=0;
char message[100];
char *rhs;
int scope;


int max(int,int);
int yylex();
int yyerror(char *s);


int dtype=9;
int IsAssign=1,nameOfreg=1;
char temp_code[40];
extern int l_count;
bool flag=true;
//extern entry_count;
char *tp;

%}

%token T_VAR T_FOR T_WHILE T_BRK T_CNT T_STRING T_ID T_CM T_SCLN T_INT T_FLOAT T_TRUE T_FALSE
%token T_OBR T_CBR T_UADD T_USUB T_SOBR T_SCBR T_FOBR T_FCBR T_OPS T_DQT
%left  T_MUL T_DIV T_MOD T_ADD T_SUB 
%right T_EQ T_MULASN T_DIVASN T_MODASN T_ADDASN T_SUBASN
%token T_GT T_GTE T_LT T_LTE T_CMP T_NEQ T_SCMP T_SNEQ T_LAND T_LOR T_AND T_OR T_XOR
%token T_NT T_BTNT T_RS T_LS
%%
Statement: DeclareStat T_SCLN Statement {printf("working\n");} | 
	   AssignExpression T_SCLN Statement {printf("Assign\n");} |
	   T_FOR T_OBR {printf("open brace forloop\n");} ForAssignExpression T_SCLN CondExpression T_SCLN 
		 UnaryExpression T_CBR{printf("close brace forloop\n");} CompoundStatement {printf("valid for loop  \n");} Statement  |
	   T_WHILE T_OBR {printf("open brace whileloop\n");} WhileCondExpression T_CBR{printf("close brace whileloop\n");}  
		CompoundStatement{printf("valid while loop  \n");} Statement  | 
		{printf("end of stat\n");};
	   //T_NL{printf("new line char\n");} | ;


DeclareStat: T_VAR list{printf("this is the varlist\n");} ;


list: T_ID {
	
		   if(lookup_var_scope(name,scope) == NULL){
			add_var(defaultc,name,scope); 
		    }				
		    else{
			printf(" Error: Variable %s is already declared,this Re-declaration is illegal\n",name);
			exit(0);
				}
	  } |  

      AssignExpression | Array |
	
	T_CM list  |
	AssignExpression T_CM list |
	Array T_CM list |T_INT|T_OPS T_STRING T_OPS |T_DQT T_STRING T_DQT|T_FLOAT;

Array: T_SOBR{printf("square braces open\n");} list T_SCBR | T_SOBR T_SCBR ;


AssignExpression: T_ID AssignOp Expression {
				add_var(dtype,name,scope);
				struct symbol *temp=lookup_var(name);
				printf("assgnng .... .. value:%s %d\n",name,$3);
				if(dtype==0){
					temp->var_type=0;
					strcpy(temp->data_type,"int");
					temp->u.a1=$3;
					temp->scope=scope;
				}
				else if(dtype==1){
					temp->var_type=1;
					temp->u.a3=(char*)malloc(sizeof(char)*strlen(str));
					temp->u.a3=str;
					temp->scope=scope;
					strcpy(temp->data_type,"char");
				}
				else if(dtype==2){
					temp->var_type=2;
					temp->u.a2=$3;
					strcpy(temp->data_type,"float");
					temp->scope=scope;
				}

		 } | T_ID T_EQ Array ;


AssignOp: T_EQ{printf("equal2\n");} | T_MULASN | T_DIVASN | T_MODASN | T_ADDASN | T_SUBASN ;

/*Expression: Expression{printf("express start\n");} ArithOp{printf("arth oper\n");} Expression{printf("express end\n");} | T_OBR{printf("open bracekt\n");} Expression ArithOp Expression T_CBR{printf("close bracekt\n");} | ExpressionTerm{printf("express term\n");} | '';
*/
Expression: Expression T_ADD Expression {printf("add\n"); $$ = $1 + $3; printf("after add:%d+%d=%d\n",$1,$3,$$);} | Exp_sub;

Exp_sub: Expression T_SUB Expression {printf("sub\n"); $$ = $1 - $3;} | 
	    Exp_mul ;


Exp_mul: Expression T_MUL Expression {printf("mult\n"); $$ = $1 * $3;} | Exp_div ; 

Exp_div: Expression T_DIV Expression {printf("div\n"); $$ = $1 / $3;} | 
	    Exp_end ;
	    

Exp_end: T_INT{printf("int of exp\n");dtype=0; $$=$1;} | T_FLOAT{printf("float of exp\n");dtype=2; $$=$1;} | T_STRING {dtype=1; $$=$1;} |
	 T_ID{
		printf("id of exp\n");
		display(head);
		if(lookup_var(name) == NULL){
			printf("Error: Variable %s has not been declared\n",name); 
			exit(0);
	 	}
		else{
			struct symbol *temp=lookup_var(name);
			printf("the variable is %s and type %d\n",temp->var_name,temp->var_type);
			if(temp->var_type==0){
					
					printf("assign value %d to $$\n",temp->u.a1);
					$$ = temp->u.a1;
			}
			else if(temp->var_type==1){
				printf("assign value %s to $$\n",temp->u.a3);
				$$ = temp->u.a3;
			}
			else if(temp->var_type==2){
				printf("assign value %f to $$\n",temp->u.a1);
				$$ = temp->u.a2;
			}				
		}	
	 } | 
	 T_OBR{printf("open bracekt\n");} Expression T_SUB Expression T_CBR{printf("close bracekt\n");} ;


ForAssignExpression: DeclareStat | AssignExpression | ;


WhileCondExpression: CondExpression | T_TRUE | T_FALSE | T_INT | T_FLOAT ;


CondExpression: Expression CondOpt Expression ;


CondOpt: logicalOpt | RelOpt ;


RelOpt:
	T_LT | T_GT | T_GTE | T_LTE | T_CMP | T_SCMP | T_NEQ | T_SNEQ ;


logicalOpt: T_LAND | T_LOR ;


UnaryExpression: UnaryOp T_ID | T_ID UnaryOp{printf("unary expression\n");} | ;


UnaryOp: T_UADD | T_USUB ;


CompoundStatement:
	T_FOBR{printf("flower open bracekt\n");++scope;} Statement T_FCBR{printf("compound\n");--scope;} ;
//ExpressionTerm: T_ID{printf("id of exp\n");} | T_NUM{printf("num of exp\n");} | T_DIGIT ;

//ArithOp: T_SUB | T_DIV | T_MUL | T_ADD{printf("add\n");} | T_MOD ;


//Start: T_VAR T_ID {printf("valid\n");};

%%
/*
int yyerror(char *msg)
{
printf("invalid string: %s \n",msg);
exit(0);
}

void main()
{
printf("enter the string\n");
yyparse();
}
*/
/*
int yywrap()
{
	
        return 1;
} */
  
int main()
{

    yyin=fopen("input.txt","r");
    symbol_table=fopen("symbol_table.txt","w");
    
    //yyout=fopen("output.js","w");	
	yyparse();
	struct symbol *temp=head;
	//temp=temp->next;
	printf("after error %d\n",entry_count);
	//struct symbol *temp=head;
    while(temp){
	fprintf(symbol_table,"%d ",temp->entry);
	fprintf(symbol_table,"%s ",temp->var_name);
	fprintf(symbol_table,"%d ",temp->var_type);
	fprintf(symbol_table,"scope: %d ",temp->scope);
	fprintf(symbol_table,"%s ",temp->data_type);
	if(temp->var_type==0)
		fprintf(symbol_table,"Value: %d \n",temp->u.a1);
	else if(temp->var_type==2)
		fprintf(symbol_table,"Value: %f \n",temp->u.a2);
	else
		fprintf(symbol_table,"Value: %s \n",temp->u.a3);
	temp=temp->next;
    }    
	if(ErrorRecovered==0) printf("Success!\n");
		fclose(symbol_table);
		fclose(yyin);

    return 0;
}



int yyerror(char *str)
{
				if(ErrorRecovered==0){
					{
					
					
						printf("Error Found @ line #%d: ", lineNum+1);
						//if(strcmp(str,"Invalid character")==0 || strcmp(str,"Identifier greater than 5 characters")==0)				;		
						//	printf("%s!", str);
						//else if(strlen(message))
						//printf("%s\n",message);
						//else printf("%s\n", str);
					}
					printf("\n");
					ErrorRecovered = 1;

				}
	return 0;
		        
}
