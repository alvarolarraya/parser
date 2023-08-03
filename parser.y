%{
#define YYDEBUG 1
#include <ctype.h>
#include <stdio.h>
int yylex();
extern int yydebug;
extern FILE* yyin;
FILE *codigoTresDirecciones;
int n_linea;
// para que el output salga al final del codigo intermedio
char output[100][100];
void yyerror(const char *s);
%}

%code requires{
   #include "TablaSimbolos.h"
   #include "TablaCuadruplas.h"
   typedef struct Tipo_expresion{
       int place;
       int tipo;
       int m_quad;
   } Tipo_expresion;
 
   typedef struct Tipo_booleanos{
       int verdadero[tamTabla];
       int cuantosVerdaderos;
       int falso[tamTabla];
       int cuantosFalsos;
       int m_quad;
   } Tipo_booleanos;
 
   typedef struct Tipo_array_int{
       int sigPosicionLibre;
       int array[tamTabla];
   }Tipo_array_int;

   typedef struct Tipo_array_nombre_variables{
        int sigPosicionLibre;
        char* array[tamTabla];
    }Tipo_array_nombre_variables;

    typedef struct Tipo_instruccion{
        int m_quad;
        int siguientes[tamTabla];
        int cuantosSiguientes;
    }Tipo_instruccion;
}
 
%union{
   Tipo_array_int paralistaid;
   Tipo_array_nombre_variables paralistavar;
   int entero;
   char cadena[tamNombre];
   Tipo_expresion paraexpresiones;
   Tipo_constantes paratipos;
   Tipo_booleanos parabooleanos;
   Tipo_oprels oprels;
   Tipo_instruccion parainstruccion;
}


%token TK_punto_coma
%left TK_punto
%token TK_dos_puntos
%token TK_coma
%token TK_subrango
%token TK_entonces
%token TK_si_no_si
%left TK_inic_array
%token TK_fin_array
%token <cadena> TK_identificador
%token <cadena> TK_identificador_b
%token TK_dos_puntos_igual
%right TK_no
%left TK_suma TK_resta
%left TK_mult TK_div TK_barra_div TK_mod
%token TK_inic_parentesis
%token TK_fin_parentesis
%token TK_referencia
%token TK_accion
%left TK_ref
%token TK_de
%token TK_algoritmo
%token TK_const
%token TK_continuar
%token TK_dev 
%token TK_ent
%token TK_faccion 
%token TK_falgoritmo
%token TK_fconst
%token TK_ffuncion
%token TK_fmientras
%token TK_fpara
%token TK_fsi
%token TK_ftipo
%token TK_ftupla 
%token TK_funcion 
%token TK_fvar
%token TK_hacer
%token TK_hasta
%token TK_mientras
%token TK_para 
%token TK_sal
%token TK_si
%token TK_tabla
%token TK_tipo
%token TK_tupla
%token TK_var
%token TK_comentario
%token TK_verdadero
%token TK_falso
%left <oprels> TK_oprel
%token TK_ent_sal
%token <paratipos> TK_tipo_base
%token TK_literal_caracter
%token TK_literal
%token TK_literal_numerico
%left TK_y
%left TK_o
%type <paralistaid> lista_id
%type <paralistavar> lista_d_var
%type <paratipos> d_tipo
%type <paraexpresiones> operando
%type <paraexpresiones> exp_a
%type <parabooleanos> exp_b
%type <parainstruccion> lista_opciones
%type <parainstruccion> alternativa
%type <parainstruccion> asignacion
%type <parainstruccion> instruccion
%type <parainstruccion> instrucciones
%type <parainstruccion> it_cota_exp


%%

desc_algoritmo: TK_algoritmo TK_identificador TK_punto_coma cabecera_alg bloque_alg TK_falgoritmo TK_punto_coma {
                                                                                                                    mostrar_tabla_simbolos();
                                                                                                                    int i;
                                                                                                                    i = 0;
                                                                                                                    while(strcmp(output[i], "-") != 0){
                                                                                                                        gen(obtener_posicion_simbolo(output[i]),OUTPUT,OPERADOR_NULO,OPERADOR_NULO);
                                                                                                                        i++;
                                                                                                                    }
                                                                                                                    mostrar_tabla_cuadruplas(codigoTresDirecciones);
                                                                                                                    fclose(codigoTresDirecciones);
                                                                                                                }
;
cabecera_alg:   decl_globales decl_a_f decl_ent_sal TK_comentario  {}
;
bloque_alg: bloque TK_comentario   {}
;
decl_globales:  declaracion_tipo decl_globales  {}
|   declaracion_cte decl_globales {}
|   %empty {}
;
decl_a_f:   accion_d decl_a_f   {}
|   funcion_d decl_a_f  {}
|   %empty {}
;
bloque: declaraciones instrucciones {}
;
declaraciones:  declaracion_tipo declaraciones  {}
|   declaracion_cte declaraciones {}
|   declaracion_var declaraciones   {}
|   %empty {}
;
declaracion_tipo:   TK_tipo lista_d_tipo TK_ftipo TK_punto_coma {}
;
declaracion_cte:    TK_const lista_d_cte TK_fconst TK_punto_coma    {}
;
declaracion_var:    TK_var lista_d_var TK_fvar TK_punto_coma    {}
;
lista_d_tipo:   TK_identificador  TK_referencia d_tipo TK_punto_coma lista_d_tipo  {}
|  %empty {}
;
d_tipo:  TK_tupla lista_campos TK_ftupla   {}
|   TK_tabla TK_inic_array expresion_t TK_subrango expresion_t TK_fin_array TK_de d_tipo   {}
|   TK_identificador   {}
|   expresion_t TK_subrango expresion_t  {}
|   TK_ref d_tipo  {}
|   TK_tipo_base   {$$=$1;}
;
expresion_t:    expresion {} 
|   TK_literal_caracter    {}
;
lista_campos:   TK_identificador TK_dos_puntos d_tipo TK_punto_coma lista_campos   {}
|   %empty {}
;
lista_d_cte:    TK_identificador TK_referencia TK_literal TK_punto_coma lista_d_cte    {}
|   %empty {}
;
lista_d_var: lista_id TK_dos_puntos d_tipo TK_punto_coma lista_d_var    {
                                                                            for (int i = 0; i < $1.sigPosicionLibre; i++){
                                                                                modifica_tipo_tabla_simbolos($1.array[i], $3);
                                                                                $$.array[i] = obtener_nombre_variable($1.array[i]);
                                                                            }
                                                                            $$.sigPosicionLibre = $1.sigPosicionLibre;
                                                                        }
|   %empty {}
;
lista_id: TK_identificador TK_coma lista_id     {
                                                    $3.array[$3.sigPosicionLibre] = newvar($1);
                                                    $3.sigPosicionLibre++;
                                                    $$ = $3;
                                                }
|   TK_identificador_b TK_coma lista_id     {
                                                    $3.array[$3.sigPosicionLibre] = newvar($1);
                                                    $3.sigPosicionLibre++;
                                                    $$ = $3;
                                                }
|   TK_identificador    {
                            $$.array[0] = newvar($1);
                            $$.sigPosicionLibre = 1;
                        }
|   TK_identificador_b    {
                            $$.array[0] = newvar($1);
                            $$.sigPosicionLibre = 1;
                        }
;
decl_ent_sal:  decl_ent {}
|   decl_ent decl_sal    {}
|   decl_sal  {}
;
decl_ent: TK_ent lista_d_var    {
                                    for (int i = 0; i < $2.sigPosicionLibre; i++){
                                        gen(obtener_posicion_simbolo($2.array[i]),INPUT,OPERADOR_NULO,OPERADOR_NULO);
                                                                            }
                                }
;
decl_sal: TK_sal lista_d_var    {
                                    for (int i = 0; i < $2.sigPosicionLibre; i++){
                                        strcpy(output[i],$2.array[i]);
                                        strcpy(output[i+1],"-");
                                    }
                                }
;
exp_b: exp_b TK_o exp_b     {
                                backpatch($1.falso,$1.cuantosVerdaderos,$3.m_quad);
                                merge($1.verdadero,$1.cuantosVerdaderos,$3.verdadero,$3.cuantosVerdaderos,$$.verdadero);
                                $$.cuantosVerdaderos = $1.cuantosVerdaderos+$3.cuantosVerdaderos;
                                $$.cuantosFalsos = $3.cuantosFalsos;
                                memcpy($$.falso, $3.falso,tamTabla*sizeof(int));
                            }
|   exp_b TK_y exp_b  {
                            backpatch($1.verdadero,$1.cuantosVerdaderos,$3.m_quad);
                            merge($1.falso,$1.cuantosFalsos,$3.falso,$3.cuantosFalsos,$$.falso);
                            $$.cuantosFalsos = $1.cuantosFalsos+$3.cuantosFalsos;
                            $$.cuantosVerdaderos = $3.cuantosVerdaderos;
                            memcpy($$.verdadero, $3.verdadero,tamTabla*sizeof(int));
                        }
|   TK_no exp_b {
                    $$ = $2;
                    memcpy($$.verdadero, $2.falso,tamTabla*sizeof(int));
                    memcpy($$.falso, $2.verdadero,tamTabla*sizeof(int));
                }
|   TK_inic_parentesis exp_b TK_fin_parentesis  {
                                                    $$ = $2;
                                                }
|   TK_identificador_b  {}
|   exp_a TK_oprel exp_a    {
                                $$.cuantosVerdaderos = 1;
                                $$.verdadero[0] = tabla_cuadruplas.sigPosLibre;
                                $$.cuantosFalsos = 1;
                                $$.falso[0] = tabla_cuadruplas.sigPosLibre+1;
                                $$.m_quad = gen_salto($2,$1.place,$3.place);
                                gen_salto(GOTO,OPERADOR_NULO,OPERADOR_NULO);
                                int m_quads_posibles[3];
                                m_quads_posibles[0] = $$.m_quad;
                                m_quads_posibles[1] = $1.m_quad;
                                m_quads_posibles[2] = $3.m_quad;
                                for(int i = 0; i < 3; i++){
                                    if((m_quads_posibles[i] != -1) && (m_quads_posibles[i] < $$.m_quad)){
                                        $$.m_quad = m_quads_posibles[i];
                                    }
                                }
                            }
|   TK_verdadero    {}
|   TK_falso        {}

;
expresion: exp_a     {}
|   exp_b  {}
|   funcion_ll  {}
;
exp_a: exp_a TK_suma exp_a      {
                                    int T = newtemp();
                                    $$.place = T;
                                    if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_ENTERO){
                                        modifica_tipo_tabla_simbolos(T, TIPO_ENTERO);
                                        $$.m_quad = gen($1.place,OPERADOR_SUMA_ENTERO,$3.place,T);
                                        $$.tipo = TIPO_ENTERO;
                                                                            }
                                    else if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_REAL){
                                        modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                        $$.m_quad = gen($1.place,OPERADOR_INT_TO_REAL,OPERADOR_NULO,T);
                                        gen(T,OPERADOR_SUMA_REAL,$3.place,T);
                                        $$.tipo = TIPO_REAL;
                                                                            }
                                    else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_ENTERO){
                                        modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                        $$.m_quad = gen($3.place,OPERADOR_INT_TO_REAL,OPERADOR_NULO,T);
                                        gen(T,OPERADOR_SUMA_REAL,$1.place,T);
                                        $$.tipo = TIPO_REAL;
                                                                            }
                                    else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_REAL){
                                        modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                        $$.m_quad = gen($1.place,OPERADOR_SUMA_REAL,$3.place,T);
                                        $$.tipo = TIPO_REAL;
                                                                            }
                                    int m_quads_posibles[3];
                                    m_quads_posibles[0] = $$.m_quad;
                                    m_quads_posibles[1] = $1.m_quad;
                                    m_quads_posibles[2] = $3.m_quad;
                                    for(int i = 0; i < 3; i++){
                                        if((m_quads_posibles[i] != -1) && (m_quads_posibles[i] < $$.m_quad)){
                                            $$.m_quad = m_quads_posibles[i];
                                        }
                                    }
                                }
                                
|   exp_a TK_resta exp_a   {
                                    int T = newtemp();
                                    $$.place = T;
                                    
                                    if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_ENTERO){
                                        modifica_tipo_tabla_simbolos(T, TIPO_ENTERO);
                                        $$.m_quad = gen($1.place,OPERADOR_RESTA_ENTERO,$3.place,T);
                                        $$.tipo = TIPO_ENTERO;
                                                                            }
                                    else if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_REAL){
                                        modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                        $$.m_quad = gen($1.place,OPERADOR_INT_TO_REAL,OPERADOR_NULO,T);
                                        gen(T,OPERADOR_RESTA_REAL,$3.place,T);
                                        $$.tipo = TIPO_REAL;
                                                                            }
                                    else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_ENTERO){
                                        modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                        $$.m_quad = gen($3.place,OPERADOR_INT_TO_REAL,OPERADOR_NULO,T);
                                        gen(T,OPERADOR_RESTA_REAL,$1.place,T);
                                        $$.tipo = TIPO_REAL;
                                                                            }
                                    else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_REAL){
                                        modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                        $$.m_quad = gen($1.place,OPERADOR_RESTA_REAL,$3.place,T);
                                        $$.tipo = TIPO_REAL;
                                                                            }
                                    int m_quads_posibles[3];
                                    m_quads_posibles[0] = $$.m_quad;
                                    m_quads_posibles[1] = $1.m_quad;
                                    m_quads_posibles[2] = $3.m_quad;
                                    for(int i = 0; i < 3; i++){
                                        if((m_quads_posibles[i] != -1) && (m_quads_posibles[i] < $$.m_quad)){
                                            $$.m_quad = m_quads_posibles[i];
                                        }
                                    }
                                }
                                
|   exp_a TK_mult exp_a {
                            int T = newtemp();
                            $$.place = T;
                            if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_ENTERO){
                                modifica_tipo_tabla_simbolos(T, TIPO_ENTERO);
                                $$.m_quad = gen($1.place,OPERADOR_PRODUCTO_ENTERO,$3.place,T);
                                $$.tipo = TIPO_ENTERO;
                            }
                            else if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_REAL){
                                modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                $$.m_quad = gen($1.place,OPERADOR_INT_TO_REAL,OPERADOR_NULO,T);
                                gen(T,OPERADOR_PRODUCTO_REAL,$3.place,T);
                                $$.tipo = TIPO_REAL;
                            }
                            else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_ENTERO){
                                modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                $$.m_quad = gen($3.place,OPERADOR_INT_TO_REAL,OPERADOR_NULO,T);
                                gen(T,OPERADOR_PRODUCTO_REAL,$1.place,T);
                                $$.tipo = TIPO_REAL;
                            }
                            else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_REAL){
                                modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                $$.m_quad = gen($1.place,OPERADOR_PRODUCTO_REAL,$3.place,T);
                                $$.tipo = TIPO_REAL;
                            }
                            int m_quads_posibles[3];
                            m_quads_posibles[0] = $$.m_quad;
                            m_quads_posibles[1] = $1.m_quad;
                            m_quads_posibles[2] = $3.m_quad;
                            for(int i = 0; i < 3; i++){
                                if((m_quads_posibles[i] != -1) && (m_quads_posibles[i] < $$.m_quad)){
                                    $$.m_quad = m_quads_posibles[i];
                                }
                            }
                        }
                                
|   exp_a TK_barra_div exp_a    {
                                    int T = newtemp();
                                    $$.place = T;
                                    
                                    if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_ENTERO){
                                        modifica_tipo_tabla_simbolos(T, TIPO_ENTERO);
                                        $$.m_quad = gen($1.place,OPERADOR_DIVISION_ENTERO,$3.place,T);
                                        $$.tipo = TIPO_ENTERO;
                                    }
                                    else if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_REAL){
                                        modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                        $$.m_quad = gen($1.place,OPERADOR_INT_TO_REAL,OPERADOR_NULO,T);
                                        gen(T,OPERADOR_DIVISION_REAL,$3.place,T);
                                        $$.tipo = TIPO_REAL;
                                    }
                                    else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_ENTERO){
                                        modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                        $$.m_quad = gen($3.place,OPERADOR_INT_TO_REAL,OPERADOR_NULO,T);
                                        gen(T,OPERADOR_DIVISION_REAL,$1.place,T);
                                        $$.tipo = TIPO_REAL;
                                    }
                                    else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_REAL){
                                        modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                                        $$.m_quad = gen($1.place,OPERADOR_DIVISION_REAL,$3.place,T);
                                        $$.tipo = TIPO_REAL;
                                    }
                                    int m_quads_posibles[3];
                                    m_quads_posibles[0] = $$.m_quad;
                                    m_quads_posibles[1] = $1.m_quad;
                                    m_quads_posibles[2] = $3.m_quad;
                                    for(int i = 0; i < 3; i++){
                                        if((m_quads_posibles[i] != -1) && (m_quads_posibles[i] < $$.m_quad)){
                                            $$.m_quad = m_quads_posibles[i];
                                        }
                                    }
                                }
|   exp_a TK_mod exp_a {
                            int T = newtemp();
                            $$.place = T;
                            
                            if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_ENTERO){
                                modifica_tipo_tabla_simbolos(T, TIPO_ENTERO);
                                $$.m_quad = gen($1.place,OPERADOR_RESTO,$3.place,T);
                                $$.tipo = TIPO_ENTERO;
                                                                    }
                            else if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_REAL){
                                yyerror("No se puede realizar la operación por los tipos de los operandos");
                            }
                            else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_ENTERO){
                                yyerror("No se puede realizar la operación por los tipos de los operandos");
                            }
                            else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_REAL){
                                yyerror("No se puede realizar la operación por los tipos de los operandos");
                            }
                            int m_quads_posibles[3];
                            m_quads_posibles[0] = $$.m_quad;
                            m_quads_posibles[1] = $1.m_quad;
                            m_quads_posibles[2] = $3.m_quad;
                            for(int i = 0; i < 3; i++){
                                if((m_quads_posibles[i] != -1) && (m_quads_posibles[i] < $$.m_quad)){
                                    $$.m_quad = m_quads_posibles[i];
                                }
                            }
                        }
|   exp_a TK_div exp_a  {
                            int T = newtemp("");
                            $$.place = T;
                            
                            if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_ENTERO){
                                modifica_tipo_tabla_simbolos(T, TIPO_ENTERO);
                                $$.m_quad = gen($1.place,OPERADOR_DIV,$3.place,T);
                                $$.tipo = TIPO_ENTERO;
                                                                    }
                            else if($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_REAL){
                                yyerror("No se puede realizar la operación por los tipos de los operandos");
                            }
                            else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_ENTERO){
                                yyerror("No se puede realizar la operación por los tipos de los operandos");
                            }
                            else if($1.tipo == TIPO_REAL && $3.tipo == TIPO_REAL){
                                yyerror("No se puede realizar la operación por los tipos de los operandos");
                            }
                            int m_quads_posibles[3];
                            m_quads_posibles[0] = $$.m_quad;
                            m_quads_posibles[1] = $1.m_quad;
                            m_quads_posibles[2] = $3.m_quad;
                            for(int i = 0; i < 3; i++){
                                if((m_quads_posibles[i] != -1) && (m_quads_posibles[i] < $$.m_quad)){
                                    $$.m_quad = m_quads_posibles[i];
                                }
                            }
                        }
|   TK_inic_parentesis exp_a TK_fin_parentesis {
                                                    $$ = $2;
                                                }
|   TK_literal_numerico {}
|   operando    {
                    $$.tipo = $1.tipo;
                    $$.place = $1.place;
                    $$.m_quad = $1.m_quad;
                }

|   TK_resta exp_a  {
                        int T = newtemp();
                        $$.place = T;
                        if ($2.tipo == TIPO_ENTERO){
                            modifica_tipo_tabla_simbolos(T, TIPO_ENTERO);
                            gen(OPERADOR_NULO, OPERADOR_RESTA_REAL, $2.place, T);
                            $$.tipo = TIPO_ENTERO;
                        }else if ($2.tipo == TIPO_REAL){
                            modifica_tipo_tabla_simbolos(T, TIPO_REAL);
                            gen(OPERADOR_NULO, OPERADOR_RESTA_REAL, $2.place, T);
                            $$.tipo = TIPO_REAL;
                        }
                        $$.m_quad = $2.m_quad;
                    }
;

operando: TK_identificador  {
                                $$.place = obtener_posicion_simbolo($1);
                                $$.tipo = consulta_tipo($1);
                                $$.m_quad = tabla_cuadruplas.sigPosLibre;
                            }
|   operando TK_punto operando   {}
|   operando TK_inic_array expresion TK_fin_array    {}
|   operando TK_ref    {}
;
instrucciones:   instruccion TK_punto_coma instrucciones    {
                                                                $$.cuantosSiguientes = $3.cuantosSiguientes;
                                                                memcpy($$.siguientes, $3.siguientes,tamTabla*sizeof(int));
                                                                $$.m_quad = $1.m_quad;
                                                            } 
|   instruccion TK_punto_coma   {$$ = $1;}
;
instruccion:     TK_continuar  {}
|   asignacion  {$$ = $1;} 
|   alternativa {} 
|   iteracion   {} 
|   accion_ll   {}
;
asignacion:     operando TK_dos_puntos_igual exp_a  {
                                                        $$.m_quad = $3.m_quad;
                                                        $$.cuantosSiguientes = 0;
                                                        if ($1.tipo == $3.tipo){
                                                            gen($3.place, OPERADOR_ASIGNACION, OPERADOR_NULO, $1.place);
                                                        } else if ($1.tipo == TIPO_REAL && $3.tipo == TIPO_ENTERO){
                                                            gen($3.place, OPERADOR_ASIGNACION, OPERADOR_NULO, $1.place);
                                                        } else if ($1.tipo == TIPO_ENTERO && $3.tipo == TIPO_REAL){
                                                            gen($3.place, OPERADOR_ASIGNACION, OPERADOR_NULO, $1.place);
                                                        } else {
                                                            yyerror("Error en la asignación\n");
                                                        }                                                        
                                                    }
|               exp_b TK_dos_puntos_igual exp_b  {}
;
alternativa:     TK_si exp_b TK_entonces instrucciones lista_opciones TK_fsi    {
                                                                                    backpatch($2.verdadero, $2.cuantosVerdaderos, $4.m_quad);
                                                                                    if($5.cuantosSiguientes != 0){
                                                                                        backpatch($2.falso, $2.cuantosFalsos, $5.siguientes[$5.cuantosSiguientes-1]);
                                                                                        merge($2.falso,$2.cuantosFalsos,$5.siguientes,$5.cuantosSiguientes,$$.siguientes);
                                                                                        $$.cuantosSiguientes = $2.cuantosFalsos+$5.cuantosSiguientes;
                                                                                    }else{
                                                                                        backpatch($2.falso, $2.cuantosFalsos, tabla_cuadruplas.sigPosLibre);
                                                                                        int nextquad[1];
                                                                                        nextquad[0] = tabla_cuadruplas.sigPosLibre;
                                                                                        merge($2.falso,$2.cuantosFalsos,nextquad,1,$$.siguientes);
                                                                                        $$.cuantosSiguientes = $2.cuantosFalsos+1;
                                                                                        gen_salto(GOTO,OPERADOR_NULO,OPERADOR_NULO);
                                                                                    }
                                                                                    $$.siguientes[$$.cuantosSiguientes] = $2.m_quad;
                                                                                    $$.cuantosSiguientes++;
                                                                                }
;
lista_opciones: TK_si_no_si exp_b TK_entonces instrucciones lista_opciones  {
                                                                                printf("mquad: %d\n", $4.m_quad);
                                                                                backpatch($2.verdadero, $2.cuantosVerdaderos, $4.m_quad);
                                                                                if($5.cuantosSiguientes != 0){
                                                                                    backpatch($2.falso, $2.cuantosFalsos, $5.siguientes[$5.cuantosSiguientes-1]);
                                                                                    merge($2.falso,$2.cuantosFalsos,$5.siguientes,$5.cuantosSiguientes,$$.siguientes);
                                                                                    $$.cuantosSiguientes = $2.cuantosFalsos+$5.cuantosSiguientes;
                                                                                }else{
                                                                                    backpatch($2.falso, $2.cuantosFalsos, tabla_cuadruplas.sigPosLibre);
                                                                                    int nextquad[1];
                                                                                    nextquad[0] = tabla_cuadruplas.sigPosLibre;
                                                                                    merge($2.falso,$2.cuantosFalsos,nextquad,1,$$.siguientes);
                                                                                    $$.cuantosSiguientes = $2.cuantosFalsos+1;
                                                                                    gen_salto(GOTO,OPERADOR_NULO,OPERADOR_NULO);
                                                                                }
                                                                                $$.siguientes[$$.cuantosSiguientes] = $2.m_quad;
                                                                                $$.cuantosSiguientes++;
                                                                            } 
| %empty    {$$.cuantosSiguientes = 0;}
;
iteracion:   it_cota_fija | it_cota_exp    {}
;
it_cota_exp:     TK_mientras exp_b TK_hacer instrucciones TK_fmientras  {
                                                                            backpatch($2.verdadero,$2.cuantosVerdaderos, $4.m_quad);
                                                                            if($4.cuantosSiguientes != 0){
                                                                                backpatch($4.siguientes,$4.cuantosSiguientes,$2.m_quad);
                                                                                backpatch($2.falso,$2.cuantosFalsos, $4.siguientes[1]+1);
                                                                            }else{
                                                                                int direccionTC = gen_salto(GOTO,OPERADOR_NULO,OPERADOR_NULO);
                                                                                backpatch($2.falso,$2.cuantosFalsos, direccionTC+1);
                                                                                tabla_cuadruplas.array[direccionTC].direccion_salto = $2.m_quad;
                                                                            }
                                                                            memcpy($$.siguientes, $2.falso,tamTabla*sizeof(int));
                                                                            $$.cuantosSiguientes = $2.cuantosFalsos;
                                                                        }
;
it_cota_fija:  TK_para TK_identificador TK_dos_puntos_igual exp_a TK_hasta exp_a TK_hacer instrucciones TK_fpara    {}
;
accion_d:   TK_accion a_cabecera bloque TK_faccion    {}
;
funcion_d:  TK_funcion f_cabecera bloque TK_dev expresion TK_ffuncion    {}
;
a_cabecera: TK_identificador TK_inic_parentesis d_par_form TK_fin_parentesis TK_punto_coma {}
;
f_cabecera: TK_identificador TK_inic_parentesis lista_d_var TK_fin_parentesis TK_dev d_tipo TK_punto_coma {}
;
d_par_form: d_p_form TK_punto_coma d_par_form  {}
|     %empty {}
;
d_p_form:   TK_ent lista_id TK_dos_puntos d_tipo  {}
|   TK_sal lista_id TK_dos_puntos d_tipo   {}
|   TK_ent_sal lista_id TK_dos_puntos d_tipo   {}
;
accion_ll:  TK_identificador TK_inic_parentesis l_ll TK_fin_parentesis  {}
;
funcion_ll: TK_identificador TK_inic_parentesis l_ll TK_fin_parentesis  {}
l_ll:  expresion TK_coma l_ll  {}
|   expresion  {}
;




%%

int main(int argc, char* argv[]){
    /* descomentar para debuggear */
    /* yydebug = 1; */
    codigoTresDirecciones = fopen("codigoTresDirecciones.txt", "w");
    if(codigoTresDirecciones == NULL){
        printf("Fallo en la creacion del fichero output.\n");
        return -1;
    }
    printf("Fichero de codigo en tres direcciones creado con exito\n");
    if(argc <= 1){
        printf("Falta un fichero que compilar, por favor pasa por argumento un fichero al ejecutar la siguiente vez.");
        return -1;
    }
    yyin = fopen(argv[1], "r");
    if(!yyin){
        printf("Fallo al abrir el fichero %s", argv[1]);
        return -1;
    }
    n_linea = 1;
    inicializar_tabla_simbolos();
    crear_tabla_cuadruplas();
    strcpy(output[0], "-");
    return yyparse();
}

void yyerror (char const *s) {
    }
