#include "TablaCuadruplas.h"

char * nombres_operaciones[] = {" + ", " - ", " * ", " / ", " + ", " - ", " * ", " / ", " ", " mod ", " div ", " int_to_real ", "-", "+", "-", "+", "input", "output","goto", "salto_linea", "or", "and", "=",">","<","<=",">=","!="};

void crear_tabla_cuadruplas(){
    tabla_cuadruplas.sigPosLibre = 1;
}

int gen(int operando1, int operador, int operando2, int resultado){
    int pos = tabla_cuadruplas.sigPosLibre;
    tabla_cuadruplas.sigPosLibre++;
    tabla_cuadruplas.array[pos].direccion_salto = -1;
    tabla_cuadruplas.array[pos].operador = operador;
    tabla_cuadruplas.array[pos].operando1 = operando1;
    tabla_cuadruplas.array[pos].operando2 = operando2;
    tabla_cuadruplas.array[pos].resultado = resultado;
    return pos;
}

void mostrar_tabla_cuadruplas(FILE* codigoTresDirecciones){
    int pos_ultima_cuadrupla = tabla_cuadruplas.sigPosLibre;
    int direccion_salto;
    //terminal
    printf("\nTABLA DE CUADRUPLAS:\n\n");
    for (int i = 1; i < pos_ultima_cuadrupla; i++) {
        printf("%d)\t", i);
        int resultado, direccion_salto;
        char nombreOperador[100];
        char* nombreOperando1 = obtener_nombre_variable(tabla_cuadruplas.array[i].operando1);
        char* nombreOperando2 = obtener_nombre_variable(tabla_cuadruplas.array[i].operando2);
        char* nombreResultado = obtener_nombre_variable(tabla_cuadruplas.array[i].resultado);
        strcpy(nombreOperador,nombres_operaciones[tabla_cuadruplas.array[i].operador]);
        resultado = tabla_cuadruplas.array[i].resultado;
        direccion_salto = tabla_cuadruplas.array[i].direccion_salto;
        if(resultado != OPERADOR_NULO){
            printf("%s := ", nombreResultado);
            if(strcmp("-", nombreOperando1) != 0){
                printf("%s", nombreOperando1);
            }
            printf("%s", nombreOperador);
            if(strcmp("-", nombreOperando2) != 0){
                printf("%s\n", nombreOperando2);
            }else{printf("\n");}
        }else if(strcmp(nombreOperador,"input") == 0){
            printf("input %s\n", nombreOperando1);
        }else if(strcmp(nombreOperador,"output") == 0){
            printf("output %s\n", nombreOperando1);
        }else if(strcmp(nombreOperador,"goto") == 0){
            printf("goto ");
            if(direccion_salto == -1){
                printf("\n");
            }else{
                printf("%d\n", direccion_salto);
            }
        }else{
            printf("if %s %s %s goto %d\n", obtener_nombre_variable(tabla_cuadruplas.array[i].operando1), nombreOperador, obtener_nombre_variable(tabla_cuadruplas.array[i].operando2), tabla_cuadruplas.array[i].direccion_salto);
        }
    }

    //fichero
    for (int i = 1; i < pos_ultima_cuadrupla; i++) {
        fprintf(codigoTresDirecciones, "%d)\t", i);
        int resultado, direccion_salto;
        char nombreOperador[100];
        char* nombreOperando1 = obtener_nombre_variable(tabla_cuadruplas.array[i].operando1);
        char* nombreOperando2 = obtener_nombre_variable(tabla_cuadruplas.array[i].operando2);
        char* nombreResultado = obtener_nombre_variable(tabla_cuadruplas.array[i].resultado);
        strcpy(nombreOperador,nombres_operaciones[tabla_cuadruplas.array[i].operador]);
        resultado = tabla_cuadruplas.array[i].resultado;
        direccion_salto = tabla_cuadruplas.array[i].direccion_salto;
        if(resultado != OPERADOR_NULO){
            fprintf(codigoTresDirecciones, "%s := ", nombreResultado);
            fprintf(codigoTresDirecciones, "%s", nombreOperando1);
            fprintf(codigoTresDirecciones, "%s", nombreOperador);
            if(strcmp("-", nombreOperando2) != 0){
                fprintf(codigoTresDirecciones, "%s\n", nombreOperando2);
            }else{fprintf(codigoTresDirecciones, "\n");}
        }else if(strcmp(nombreOperador,"input") == 0){
            fprintf(codigoTresDirecciones, "input %s\n", nombreOperando1);
        }else if(strcmp(nombreOperador,"output") == 0){
            fprintf(codigoTresDirecciones, "output %s\n", nombreOperando1);
        }else if(strcmp(nombreOperador,"goto") == 0){
            fprintf(codigoTresDirecciones, "goto ");
            if(direccion_salto == -1){
                fprintf(codigoTresDirecciones, "\n");
            }else{
                fprintf(codigoTresDirecciones, "%d\n", direccion_salto);
            }
        }else{
            fprintf(codigoTresDirecciones, "if %s %s %s goto %d\n", obtener_nombre_variable(tabla_cuadruplas.array[i].operando1), nombreOperador, obtener_nombre_variable(tabla_cuadruplas.array[i].operando2), tabla_cuadruplas.array[i].direccion_salto);
        }
    }
}

int gen_salto(int operador,int operando1,int operando2){
    return gen(operando1,operador,operando2,OPERADOR_NULO);
}

void backpatch(int* listaCuadruplas, int tamLista, int direccion_salto){
    for(int i = 0; i < tamLista; i++){
        if(tabla_cuadruplas.array[listaCuadruplas[i]].direccion_salto == -1){
            tabla_cuadruplas.array[listaCuadruplas[i]].direccion_salto = direccion_salto;
        }
    }
}

void merge(int* lista1,int tam1,int* lista2,int tam2, int* listaResultado){
    // la listaResultado se queda con los elementos de lista1 y lista2 concatenados
    for (int i = 0; i < tam1; i++) {
        listaResultado[i] = lista1[i]; 
    }
    for(int i = tam1; i<tam1+tam2; i++){
        listaResultado[i] = lista2[i-tam1];
    }
}