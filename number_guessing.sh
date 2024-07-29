#!/bin/bash
#Para generar un numero random entre 1 y 10
RAND=$((1 + $RANDOM % 10))
#veo si el usuario lo adivino
function MAIN() {
	if [[ $1 ]]; then
		echo "Lo siento ese no es el numero. Intentelo de nuevo. Ingrese enter para dejar de jugar"
	fi
	read NUMERO
	#si el usuario no ingresa nada, se termina el juego
	if [[ -z $NUMERO ]]; then 
		exit
	fi
	if [[ $NUMERO = $RAND ]]; then
		#si el usuario adivina, se da el mensaje y se termina la funcion
		echo "Lo has adivinado! Es $NUMERO"
	else
		#en caso de no adivinar, se vuelve a llamar a la funcion con un argumento cualquiera para que se muestre el mensaje del principio de la funcion
		MAIN 1
	fi
}
MAIN
