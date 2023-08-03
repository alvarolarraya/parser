#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H
#define tamTabla 100
#define tamNombre 100

#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

typedef enum Tipo_constantes
{
    TIPO_ENTERO,
    TIPO_REAL,
    TIPO_BOOLEANO,
    TIPO_CARACTER,
    TIPO_STRING
} Tipo_constantes;

typedef struct Simbolo
{
    char nombre[tamNombre];
    int tipo; 
    int id; 
} Simbolo;

typedef struct TS
{
    int sigTemporalLibre;
    int sigPosLibre;
    int sigIdLibre;
    Simbolo array[tamTabla];
} TS;

TS tabla_simbolos;

void inicializar_tabla_simbolos();
int obtener_posicion_simbolo(char [tamNombre]);
int newtemp();
int newvar(char[tamNombre]);
void modifica_tipo_tabla_simbolos(int, int);
int consulta_tipo(char[tamNombre]);
void mostrar_tabla_simbolos();
char* obtener_nombre_variable(int);
#endif
