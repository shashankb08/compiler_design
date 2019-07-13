#include "symtab.h"
#include<string.h>
#include<stdio.h>
#include<stdlib.h>

int entry_count=1;
struct symbol* lookup_var(char *var){
	struct symbol *temp=head;
	while(temp){
			if(strcmp(temp->var_name,var)==0){
			return(temp);	
			}
	temp=temp->next;
	}
	return(NULL);
}

void display(struct symbol *head)
{
    while (head!= NULL)
    {
        printf("%s %d\n",head->var_name,head->scope);
        head = head->next;
    }
    printf("\n");
}

struct symbol* lookup_var_scope(char *var,int scope){
	struct symbol *temp=head;
	while(temp){
			if((strcmp(temp->var_name,var)==0) && (temp->scope==scope)){
			return(temp);	
			}
	temp=temp->next;
	}
	return(NULL);
}



int add_var(int type, char *var,int scope){
	
	struct symbol *temp;	
	temp = (struct symbol*)malloc(sizeof(struct symbol));
	temp->var_type = type;
	switch(type){
			case 0:
				strcpy(temp->data_type,"int");
				break;
			case 1:
				strcpy(temp->data_type,"char");
				break;
			case 2:
				strcpy(temp->data_type,"float");
				break;	
			case 3:
				strcpy(temp->data_type,"noval");
				break;				
	}
	temp->var_name = (char *)malloc(strlen(var)+1);
	temp->entry=entry_count++;
	strcpy(temp->var_name,var);
	temp->scope;
 	temp->next = head;	
//	printf("problem\n");
	head = temp;
	
	//fprintf(symbol_table,"%d ",temp->entry);
	//fprintf(symbol_table,"%s ",temp->var_name);
	//fprintf(symbol_table,"%s \n",temp->data_type);
	
	return(1);	
}

