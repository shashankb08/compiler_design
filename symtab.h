#include<stdio.h>
#include<stdlib.h>
#define intc 0
#define charc 1
#define floatc 2
#define defaultc 3
struct symbol* lookup_var(char *var);
void display(struct symbol *head);
struct symbol* lookup_var_scope(char *var,int scope);
int add_var(int type, char *var,int scope);
char *name,*str;
extern lineNum;

union val{
	int a1;
	float a2;
	char *a3;
};

struct symbol{
	char *var_name;
	int entry;
	int var_type;
	int scope;
	char data_type[7];
	union val u;
	struct symbol *next;
};

struct symbol *head;

enum {false=0,true};

typedef int bool;

FILE *code;
FILE *abstract_tree;
FILE *symbol_table;

int lable_count,lable_exit_count,label_loop_count;



