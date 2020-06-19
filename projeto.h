#define FICHEIRO "dados.bin"
#define COLUNAS		8
#define LINHAS		20
#define	MAX_TEXTO	20
#define	TIPO_NUMERO	1
#define TIPO_TEXTO	2
#define TIPO_FORM   3


struct dados {
	double	numero;
	char	texto[MAX_TEXTO];
	int		tipo;	
	
};
typedef struct dados DADOS;