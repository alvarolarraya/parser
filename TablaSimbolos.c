#include "TablaSimbolos.h"

const char * nombres_tipos[] = {"entero", "real", "booleano", "caracter", "string"};

void inicializar_tabla_simbolos(){
    // todos los nombres de las variables las inicializo con un token que no puede ser identificador
    for (int i = 0; i < tamTabla; i++)
    {
        strcpy(tabla_simbolos.array[i].nombre, "-");
    }
    tabla_simbolos.sigPosLibre = 0;
    tabla_simbolos.sigIdLibre = 0;
    tabla_simbolos.sigTemporalLibre = 0;
}

int obtener_posicion_simbolo(char nombre[tamNombre]){
    for (int i = 0; i < tamTabla; i++)
    {
        if(strcmp(nombre, tabla_simbolos.array[i].nombre) == 0){
            return i;
        }
    }
    return -1;
}

int newvar(char nombreVariable[tamNombre]){
    int pos = tabla_simbolos.sigPosLibre;
    tabla_simbolos.array[pos].id = tabla_simbolos.sigIdLibre;
    strcpy(tabla_simbolos.array[pos].nombre,nombreVariable);
    //el tipo no lo sabemos todavía
    tabla_simbolos.sigIdLibre++;
    tabla_simbolos.sigPosLibre++;
    return tabla_simbolos.array[pos].id;
}

int newtemp(){
    char nombreVariable[tamNombre];
    sprintf(nombreVariable,"T%d", tabla_simbolos.sigTemporalLibre);
    tabla_simbolos.sigTemporalLibre++;
    return newvar(nombreVariable);
}

void modifica_tipo_tabla_simbolos(int id, int tipo){
    //la posicion en la TS al no borrar simbolos es la misma que el id
    tabla_simbolos.array[id].tipo = tipo;
}

int consulta_tipo(char nombre[tamNombre]){
    int pos = obtener_posicion_simbolo(nombre);
    int tipo = tabla_simbolos.array[pos].tipo;
    return tipo;
}

void mostrar_tabla_simbolos(){
    int pos_ultimo_simbolo = tabla_simbolos.sigPosLibre;
    printf("\nTABLA DE SIMBOLOS:\n\n");
    printf("nombre:\t");
    for (int i = 0; i < pos_ultimo_simbolo; i++) {
        printf("%s", tabla_simbolos.array[i].nombre);
        if(i != pos_ultimo_simbolo-1){
            printf("   \t");
        }
    }
    printf("\n");
    printf("id:\t");
    for (int i = 0; i < pos_ultimo_simbolo; i++) {
        printf("%d", tabla_simbolos.array[i].id);
        if(i != pos_ultimo_simbolo-1){
            printf(" ->\t");
        }
    }
    printf("\n");
    printf("tipo:\t");
    for (int i = 0; i < pos_ultimo_simbolo; i++) {
        printf("%s", nombres_tipos[tabla_simbolos.array[i].tipo]);
        if(i != pos_ultimo_simbolo-1){
            printf("\t");
        }
    }
    printf("\n\n");
}

char* obtener_nombre_variable(int id){
    return tabla_simbolos.array[id].nombre;
}
