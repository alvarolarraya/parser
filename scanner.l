%{
   #include "parser.tab.h"
   int n_linea;
%}
/* Expresiones regulares básicas */
delim [ \t]
salto_linea [\n]
letra [A-Za-z]
cifra [0-9]
identificador {letra}({letra}|{cifra})*
b_identificador b_{identificador}
/* Literales */
literal_entero (\+|−)?{cifra}{cifra}*((e|E){cifra}{cifra}*)?
literal_real (\+|−)?{cifra}{cifra}*(.{cifra}{cifra}*)?((e|E){cifra}{cifra}*)?
literal_caracter \".\"
literal_cadena \'([^\']|\/\')*\'
/* Miscelánea */
comentario \{([^\}]|\/\})*\}
/* Operadores básicos */
opba_asignacion_variable :=
opba_definicion_variable :
opba_entonces ->
/* Operadores aritméticos */
opar_abrir_parentesis \(
opar_cerrar_parentesis \)
opar_suma \+
opar_resta -
opar_mod %
opar_producto \*
opar_rango \.\.
opar_division div
opar_barra_div "/"
/* Operadores lógicos */
oplo_igual =
oplo_mayor >
oplo_menor <
oplo_menor_igual <=
oplo_mayor_igual >=
oplo_desigual <>
oplo_y AND
oplo_o OR
oplo_no !
/* Operadores EEDD */
oped_apertura_tabla \[
oped_cierre_tabla \]
/* Palabras reservadas */
res_accion (?i:accion)
res_algoritmo (?i:algoritmo)
res_const (?i:const)
res_continuar (?i:continuar)
res_de (?i:de)
res_dev (?i:dev)
res_div (?i:div)
res_ent (?i:ent)
res_es (?i:e\/s)
res_faccion (?i:faccion)
res_falgoritmo (?i:falgoritmo)
res_falso (?i:falso)
res_fconst (?i:fconst)
res_ffuncion (?i:ffuncion)
res_fmientras (?i:fmientras)
res_fpara (?i:fpara)
res_fsi (?i:fsi)
res_ftipo (?i:ftipo)
res_ftupla (?i:ftupla)
res_funcion (?i:funcion)
res_fvar (?i:fvar)
res_hacer (?i:hacer)
res_hasta (?i:hasta)
res_mientras (?i:mientras)
res_mod (?i:mod)
res_no (?i:no)
res_o (?i:o)
res_para (?i:para)
res_ref (?i:ref)
res_sal (?i:sal)
res_si (?i:si)
res_sinosi (?i:\[\])
res_tabla (?i:tabla)
res_tipo (?i:tipo)
res_tupla (?i:tupla)
res_var (?i:var)
res_verdadero (?i:verdadero)
res_y (?i:y)
/* Palabras reservadas (tipos)*/
res_real (?i:real)
res_booleano (?i:booleano)
res_cadena (?i:cadena)
res_caracter (?i:caracter)
res_entero (?i:entero)

coma ,
punto_coma ;
%%
   /*univaluados*/
{punto_coma} {return TK_punto_coma;}
{coma} {return TK_coma;}
{opar_abrir_parentesis} {return TK_inic_parentesis;} 
{opar_cerrar_parentesis} {return TK_fin_parentesis;} 
{opba_asignacion_variable} {return TK_dos_puntos_igual;} 
{opba_definicion_variable} {return TK_dos_puntos;}
{opba_entonces} {return TK_entonces;} 
{opar_suma} {return TK_suma;} 
{opar_resta} {return TK_resta;} 
{opar_mod} {return TK_mod;}
{opar_producto} {return TK_mult;} 
{opar_rango} {return TK_subrango;} 
{opar_division} {return TK_div;} 
{opar_barra_div} {return TK_barra_div;}
{oplo_y} {return TK_y;} 
{oplo_o} {return TK_o;}
{oplo_no} {return TK_no;}
{oped_apertura_tabla} {return TK_inic_array;}
{oped_cierre_tabla} {return TK_fin_array;}
{res_accion} {return TK_accion;}
{res_algoritmo} {return TK_algoritmo;}

 /* OPERADORES RELACIONALES */
{oplo_igual}   {
                  yylval.oprels = OPERADOR_IGUAL;
                  return TK_oprel;
               }
{oplo_mayor}   {
                  yylval.oprels = OPERADOR_MAYOR;
                  return TK_oprel;
               }
{oplo_menor}   {
                  yylval.oprels = OPERADOR_MENOR;
                  return TK_oprel;
               }
{oplo_menor_igual}   {
                        yylval.oprels = OPERADOR_MENOR_IGUAL;
                        return TK_oprel;
                     }
{oplo_mayor_igual}   {
                        yylval.oprels = OPERADOR_MAYOR_IGUAL;
                        return TK_oprel;
                     }
{oplo_desigual}   {
                     yylval.oprels = OPERADOR_DESIGUAL;
                     return TK_oprel;
                  }

 /* PARATIPOS*/
{res_booleano} {
                  yylval.paratipos= TIPO_BOOLEANO;
                  return TK_tipo_base;
               }
{res_cadena}   { 
                  yylval.paratipos= TIPO_STRING;
                  return TK_tipo_base;
               }
{res_caracter} { 
                  yylval.paratipos= TIPO_CARACTER;
                  return TK_tipo_base;
               }       
{res_entero}   { 
                  yylval.paratipos= TIPO_ENTERO;
                  return TK_tipo_base;
               }        
{res_real}     { 
                  yylval.paratipos= TIPO_REAL;
                  return TK_tipo_base;
               }


{res_const} {return TK_const;}
{res_continuar} {return TK_continuar;}
{res_de} {return TK_de;}
{res_dev} {return TK_dev;}
{res_div} {return TK_div;}
{res_ent} {return TK_ent;}
{res_es} {return TK_ent_sal;}
{res_faccion} {return TK_faccion;}
{res_falso} {return TK_falso;}
{res_fconst} {return TK_fconst;}
{res_ffuncion} {return TK_ffuncion;}
{res_fmientras} {return TK_fmientras;}
{res_fpara} {return TK_fpara;}
{res_fsi} {return TK_fsi;}
{res_tipo} {return TK_tipo;}
{res_ftipo} {return TK_ftipo;}
{res_tupla} {return TK_tupla;}
{res_ftupla} {return TK_ftupla;}
{res_funcion} {return TK_funcion;}
{res_var} {return TK_var;}
{res_fvar} {return TK_fvar;}
{res_hacer} {return TK_hacer;}
{res_hasta} {return TK_hasta;}
{res_mientras} {return TK_mientras;}
{res_mod} {return TK_mod;}
{res_no} {return TK_no;}
{res_o} {return TK_o;}
{res_para} {return TK_para;}
{res_ref} {return TK_ref;}
{res_sal} {return TK_sal;}
{res_si} {return TK_si;}
{res_sinosi} {return TK_si_no_si;}
{res_tabla} {return TK_tabla;}
{res_verdadero} {return TK_verdadero;}
{res_falgoritmo} {return TK_falgoritmo;}
{res_y} {return TK_y;}
{literal_entero}  {return TK_literal_numerico;}
{literal_real} {return TK_literal_numerico;}
{literal_caracter}   {return TK_literal_caracter;}
{literal_cadena} {return TK_literal;}
{identificador}   {
                     strcpy(yylval.cadena, strdup(yytext));
                     return TK_identificador;
                  }
{b_identificador} {strcpy(yylval.cadena, strdup(yytext));return TK_identificador_b;}
{comentario} {return TK_comentario;}

{delim}* {}
{salto_linea} {n_linea++;}
%%
 
 

