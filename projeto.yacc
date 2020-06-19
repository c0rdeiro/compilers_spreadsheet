%{
#include <stdio.h>
#include <math.h>
#include "projeto.h"
#include <string.h> 
#include <stdlib.h>

DADOS matriz[COLUNAS][LINHAS];
int 	linha = 0;
int 	coluna = 0;
double 	value = 0;
int 	count = 0;
double 	max = 0;
double 	min = 0;
double 	aux;
char  	auxUi[MAX_TEXTO];
int    	auxInt;
char 	userInput[MAX_TEXTO];
int 	iaux = 0;
int 	stackaux = 0;


FILE* fp;
%}

%union {
	int		ival;
	char*	sval;
	double  dval;
	char 	cval;
}
%left '+' '-'
%left '*' '/'
%left UMINUS
%right '^'

%token <ival> SETA_ESQ SETA_BAIXO SETA_DIR SETA_CIMA HOME EXIT SAVEEXIT SAVE READ END ROUND
%token <sval> TEXTO SUM MAX MIN ASC DESC AVG GO
%token <dval> NUMERO 
%type  <sval> cmd
%type  <dval> arit
%start lista 





%%
	

lista:	cmd '\n'
			{ imprimir(); }
	| 
		lista cmd '\n'
			{ imprimir(); }
	| 
		arit  '\n'
			{ 	
				matriz[coluna][linha].numero = $1;
			    matriz[coluna][linha].tipo = TIPO_FORM;
				postfixToInfix();
			}
	| 
		lista arit '\n'
			{ 	matriz[coluna][linha].numero = $2;
			    matriz[coluna][linha].tipo = TIPO_FORM;
				postfixToInfix();
			}				
	;

cmd:	NUMERO
			{
			  matriz[coluna][linha].numero = $1; 
			  matriz[coluna][linha].tipo = TIPO_NUMERO; 
			}
	| '-' NUMERO
			{
				matriz[coluna][linha].numero = -$2;
				matriz[coluna][linha].tipo = TIPO_NUMERO;
			} %prec UMINUS
	
	|	TEXTO
			{ strcpy(matriz[coluna][linha].texto, $1);
			  matriz[coluna][linha].tipo = TIPO_TEXTO;
			  int mambojambo = 0;
			  size_t length = strlen($1), i = 0;
			  for (; i < length; i++) {
    		  	mambojambo += ($1[i] - '0');
			  }
			  matriz[coluna][linha].numero = mambojambo;
			}
	|	SUM '(' NUMERO  NUMERO ';' NUMERO  NUMERO ')'
			{ value = 0;
			
			for(int i =  (int)$4; i <=  (int)$7; i++){
                for(int j =  (int)$3; j <=  (int)$6; j++){
					if(matriz[j][i].tipo == 1 || matriz[j][i].tipo == 3){
						if(linha == i && coluna == j) {continue;}
						else value += matriz[j][i].numero;
					}
					
						}
                }
				matriz[coluna][linha].numero = value;
				matriz[coluna][linha].tipo = TIPO_FORM;
				strcpy(matriz[coluna][linha].texto, $$);
				}
	|	AVG '(' NUMERO  NUMERO ';' NUMERO  NUMERO ')'
			{ value = 0;
			  count = 0;
			 
			for(int i = (int)$4; i <= (int)$7; i++)
                for(int j = (int)$3; j <= (int)$6; j++){
					if(matriz[j][i].tipo == 1 || matriz[j][i].tipo == 3){
						value += matriz[j][i].numero;
						count ++;
					}
                }
				matriz[coluna][linha].numero = value/count;
				matriz[coluna][linha].tipo = TIPO_FORM;
				strcpy(matriz[coluna][linha].texto, $$);
				}
	|	MAX '(' NUMERO  NUMERO ';' NUMERO  NUMERO ')'
			{ 
			
			  max = matriz[(int)$3][(int) $4].numero;
			for(int i = $4; i <= $7; i++)
                for(int j = $3; j <= $6; j++){	
					if(matriz[j][i].numero > max && matriz[j][i].tipo != 2) 
						max = matriz[j][i].numero;
                }
				matriz[coluna][linha].numero = max;
				matriz[coluna][linha].tipo = TIPO_FORM;
				strcpy(matriz[coluna][linha].texto, $$);
				}
	|	MIN '(' NUMERO  NUMERO ';' NUMERO  NUMERO ')'
			{ 
			min = matriz[(int)$3][(int)$4].numero;
			for(int i = (int)$4; i <= (int)$7; i++)
                for(int j = (int)$3; j <= (int)$6; j++){	
					if(matriz[j][i].numero < min && matriz[j][i].tipo != 2) 
						min = matriz[j][i].numero;
                }
				matriz[coluna][linha].numero = min;
				matriz[coluna][linha].tipo = TIPO_FORM;
				strcpy(matriz[coluna][linha].texto, $$);
				}
	|	ASC '(' NUMERO ')'
			{ 
			 
		
         for (int i = 0; i < LINHAS; i++)
        {
            for (int k = i + 1; k < LINHAS; k++)
            {	
				if (matriz[(int)$3][i].numero > matriz[(int)$3][k].numero){
					aux = matriz[(int)$3][i].numero;
					strcpy(auxUi, matriz[(int)$3][i].texto);
					auxInt = matriz[(int)$3][i].tipo;

					matriz[(int)$3][i].numero = matriz[(int)$3][k].numero;
					strcpy(matriz[(int)$3][i].texto, matriz[(int)$3][k].texto);
					matriz[(int)$3][i].tipo = matriz[(int)$3][k].tipo;

					matriz[(int)$3][k].numero =aux;
					strcpy(matriz[(int)$3][k].texto, auxUi);
					matriz[(int)$3][k].tipo = auxInt;
				}
            }
        }

    
	}
	|	DESC '(' NUMERO ')'
			{ 
			
    
        for (int i = 0; i < LINHAS; i++)
        {
            for (int k = i + 1; k < LINHAS; k++)
            {
               if (matriz[(int)$3][i].numero < matriz[(int)$3][k].numero){
					aux = matriz[(int)$3][i].numero;
					strcpy(auxUi, matriz[(int)$3][i].texto);
					auxInt = matriz[(int)$3][i].tipo;

					matriz[(int)$3][i].numero = matriz[(int)$3][k].numero;
					strcpy(matriz[(int)$3][i].texto, matriz[(int)$3][k].texto);
					matriz[(int)$3][i].tipo = matriz[(int)$3][k].tipo;

					matriz[(int)$3][k].numero =aux;
					strcpy(matriz[(int)$3][k].texto, auxUi);
					matriz[(int)$3][k].tipo = auxInt;
				}
            }
        }
    
				}
	|   ROUND
			{ 
				if(matriz[coluna][linha].tipo == 1 || matriz[coluna][linha].tipo == 3){
					matriz[coluna][linha].numero = round(matriz[coluna][linha].numero);	
				}
			}										
	|	SETA_ESQ
			{ if(coluna > 0) coluna--; }
	|	SETA_BAIXO
			{ if(linha < LINHAS-1) linha++; }
	|	SETA_DIR
			{ if(coluna < COLUNAS-1) coluna++; }
	|	SETA_CIMA
			{ if(linha > 0) linha--; }
	|   HOME
			{ linha = 0;
			  coluna = 0;
			  }
	|   END
			{ linha = LINHAS - 1;
			  coluna = COLUNAS - 1;
			  }
	|   SAVE
			{ 	
				save();
			}
	|   READ
			{ 	fp = fopen(FICHEIRO, "rb");
                fread(matriz, sizeof(matriz), 1, fp);
                fclose(fp);
			}
	|   EXIT
			{ 
				exit(0);
			}
	|   SAVEEXIT
			{	
				save(); 
				exit(0);
			}
	|   GO '(' NUMERO NUMERO ')'
			{	
				coluna = $3;
				linha = $4;
			}
									
	;
arit: NUMERO NUMERO {
						char cToStr[2];
						cToStr[0] = colToChar((int)$1);
						cToStr[1] = '\0';
						char buffer[64];                         
						snprintf(buffer, sizeof buffer, "%.f", $2);                         
						strcat(userInput, cToStr);
						strcat(userInput, buffer);
						strcat(userInput, " ");
						iaux++;
						$$ = matriz[(int)$1][(int)$2].numero;}
	| '(' arit ')'  {
						$$ = $2;
					}
 	| arit '+' arit {	char cToStr[4];
						cToStr[0] = ' ';
						cToStr[1] = '+';
						cToStr[2] = ' ';
						cToStr[3] = '\0';
						strcat(userInput, cToStr);
						iaux++;
						$$ = $1 + $3;}
	| arit '-' arit {	char cToStr[4];
						cToStr[0] = ' ';
						cToStr[1] = '-';
						cToStr[2] = ' ';
						cToStr[3] = '\0';
						strcat(userInput, cToStr);
						iaux++;
						$$ = $1 - $3;}
	| arit '*' arit {	char cToStr[4];
						cToStr[0] = ' ';
						cToStr[1] = '*';
						cToStr[2] = ' ';
						cToStr[3] = '\0';
						strcat(userInput, cToStr);
						iaux++;
						$$ = $1 * $3;}
	| arit '/' arit {	char cToStr[4];
						cToStr[0] = ' ';
						cToStr[1] = '/';
						cToStr[2] = ' ';
						cToStr[3] = '\0';
						strcat(userInput, cToStr);
						iaux++;
						$$ = $1 / $3;}
	| arit '^' arit {	char cToStr[4];
						cToStr[0] = ' ';
						cToStr[1] = '^';
						cToStr[2] = ' ';
						cToStr[3] = '\0';
						strcat(userInput, cToStr);
						iaux++;
						$$ = pow($1,$3);}
	
	;


	
%%

int yylex();

int yyerror (char* s) {
	fprintf(stderr, "%s\n", s);
}
char colToChar(int col) {
	switch(col){
					case 0:
						return 'A';
					case 1:
						return 'B';
					case 2:
						return 'C';
					case 3:
						return 'D';
					case 4:
						return 'E';;
					case 5:
						return 'F';
					case 6:
						return 'G';
					case 7:
						return 'H';
				}
}

int imprimir() {
	int i, j;
	// Imprimir célula especial

	printf("%c%d: ", colToChar((int)coluna), linha);
	if(matriz[coluna][linha].tipo == TIPO_TEXTO)
        printf("%s\n", matriz[coluna][linha].texto);
	else if(matriz[coluna][linha].tipo == TIPO_FORM) printf("%s\n", matriz[coluna][linha].texto);
    else
        printf("%.2f\n", matriz[coluna][linha].numero);
	
	// Imprimir matriz
	for(i=0; i<LINHAS; i++) {
		if(i==0){
			printf("\t");
			for(int g=0; g<COLUNAS; g++)
				printf("%c\t", colToChar(g));
				
			printf("\n\n");
		}
		printf("%d\t", i);
		
		
		for(j=0; j<COLUNAS; j++) {
			if(matriz[j][i].tipo == 2)
				printf("%s\t", &matriz[j][i].texto[1]);
			else
				printf("%.2f\t", matriz[j][i].numero);
		}
		printf("\n");
	}
}

int postfixToInfix(){
	
				char ** res = NULL;
				char * p = strtok (userInput, " ");
				int  i = 0, h = 0, g = 0;
				char charFinal[MAX_TEXTO];

				while(p)
					{
						res = realloc (res, sizeof (char*) * ++i);

  						if (res == NULL)
    					exit (-1);

 						res[i-1] = p;

  						p = strtok (NULL, " ");
				 
					}
				res = realloc (res, sizeof (char*) * (i+1));
				res[i] = 0;
				int size = i;
				char *arrayStack[50];
				for (h = 0; h < size; ++h){
					if(strcmp(res[h],"+") == 0 || strcmp(res[h],"-") == 0 || strcmp(res[h],"*") == 0 || strcmp(res[h],"/") == 0 || strcmp(res[h],"^") == 0){
						char lapadentrojoca[MAX_TEXTO];
						memset(lapadentrojoca,'\0',strlen(lapadentrojoca));
						strcat(lapadentrojoca, arrayStack[stackaux-2]);
						strcat(lapadentrojoca, res[h]);
						strcat(lapadentrojoca, arrayStack[stackaux-1]);
						stackaux -= 2;
						strcpy(arrayStack[stackaux], lapadentrojoca);
						stackaux++;		
					}else{
							arrayStack[stackaux] = res[h];
							stackaux++;
						}
				}
				
				strcpy(matriz[coluna][linha].texto, arrayStack[stackaux-1]);
				free(res);
				memset(userInput,'\0',sizeof(userInput));
				imprimir();
}

int save(){
	fp = fopen(FICHEIRO, "wb");
    fwrite(matriz, sizeof(matriz), 1, fp);
    fclose(fp);
}

int main() {
	imprimir();
	return yyparse();
}


