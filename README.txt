Como ejecutar el procesador:
    Compilar: make
    Ejecutar: ./a.out ejemplos/ejemploDeseado.txt

Para eliminar los ficheros que se utilizan en la ejecución sirve con hacer make clean.

Nuestro parser es capaz de analizar expresiones aritméticas, booleanas, condiciones if y bucles de numero de iteraciones variables. Contamos con 6 ejemplos para probar dichas funcionalidades.

Una vez ejecutado código el programa saca por pantalla la tabla de símbolos, el código intermedio e indicaciones de errores con las líneas en las que se producen. Ademas el código intermedio se escribe también en un fichero de texto.

Hemos usado Fortran para las expresiones booleanas, los identificadores de tipo booleano tienen que llevar delante 'b_' y hemos distinguido entre expresión booleana y aritmética tratando ambas de distinta forma y asignándole tipos distintos. Para almacenar elementos hemos usado listas estáticas de tamaño 100, junto con un entero que nos dice la primera posición que contiene hueco libre para añadir un nuevo elemento.

El reparto de trabajo ha sido equitativo tanto en el laboratorio al que hemos acudido todos todas las clases a excepción de en dos ocasiones, como fuera de él ya que hemos hecho videollamadas para avanzar en el proyecto.

Integrantes del equipo: Alejandro Martinez, Rubén Iriso y Álvaro Larraya.