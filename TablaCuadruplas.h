#ifndef TABLA_CUADRUPLAS_H
#define TABLA_CUADRUPLAS_H
#define tamTabla 100
#include <stdlib.h>
#include <stdbool.h>
#include "TablaSimbolos.h"

typedef enum codigo_operacion
{
    OPERADOR_SUMA_ENTERO,
    OPERADOR_RESTA_ENTERO,
    OPERADOR_PRODUCTO_ENTERO,
    OPERADOR_DIVISION_ENTERO,
    OPERADOR_SUMA_REAL,
    OPERADOR_RESTA_REAL,
    OPERADOR_PRODUCTO_REAL,
    OPERADOR_DIVISION_REAL,
    OPERADOR_ASIGNACION,
    OPERADOR_RESTO,
    OPERADOR_DIV,
    OPERADOR_INT_TO_REAL,
    OPERADOR_SIGNO_RESTA_ENTERO,
    OPERADOR_SIGNO_SUMA_ENTERO,
    OPERADOR_SIGNO_RESTA_REAL,
    OPERADOR_SIGNO_SUMA_REAL,
    INPUT,
    OUTPUT,
    GOTO,
    OPERADOR_OR,
    OPERADOR_AND,
    OPERADOR_NULO
} codigo_operacion;

typedef enum Tipo_oprels
{
    OPERADOR_IGUAL = 22,
    OPERADOR_MAYOR,
    OPERADOR_MENOR,
    OPERADOR_MENOR_IGUAL,
    OPERADOR_MAYOR_IGUAL,
    OPERADOR_DESIGUAL
} Tipo_oprels;




typedef struct cuadrupla{
    int operador;
    int operando1;
    int operando2;
    int resultado;
    // para booleanas
    int direccion_salto;
}cuadrupla;

typedef struct Tabla_cuadruplas{
    int sigPosLibre;
    cuadrupla array[tamTabla];    
} Tabla_cuadruplas;

Tabla_cuadruplas tabla_cuadruplas;

void crear_tabla_cuadruplas();
int gen(int, int, int, int);
int gen_salto(int,int,int);
void mostrar_tabla_cuadruplas(FILE*);
void backpatch(int[], int, int);
void merge(int[],int,int[],int,int[]);

#endif
