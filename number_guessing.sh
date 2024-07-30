#!/bin/bash
#Es necesario crear el database corriendo el archivo crearDatabaseNumberGuessing.sql desde la terminal de postgresql parado 
#en el database postgresql, o en cualquier otro database. 
#Para correr un archivo sql desde la terminal postgres, se debe abril la terminal en el directorio donde esta el archivo, y usar el comando \i archivo.sql

#me conecto al database ya creado
export PGPASSWORD='toor'
PSQL="psql -U root -d number_guessing -h 127.0.0.1 --tuples-only -c"

function MAIN() {
	#Para generar un numero random entre 1 y 1000
	echo "Enter your user name:"
	read NAME_USER
	NAME=$($PSQL "SELECT user_name FROM users WHERE user_name='$NAME_USER'" | sed -E 's/^ *| *$//g')
	if [[ -z $NAME ]]; then
		#si el usuario no esta en la base de datos, debo agregarlo
		echo "Welcome, $NAME! It looks like this is your first time here."
		#inserto al nuevo usuario en la base de datos de usuario
		INSERT_USER=$($PSQL "INSERT INTO users(user_name) VALUES ('$NAME_USER')")
		#me quedo con el id
		USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name='$NAME'" | sed -E 's/^ *| *$//g')
	else
		#si el usuario ya estaba en la base de datos, debo saludarlo, dar la cantidad de juegos que jugo, y el mejor juego que tuvo
		USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name='$NAME'" | sed -E 's/^ *| *$//g')
		CANT_JUEGOS=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id=$USER_ID" | sed -E 's/^ *| *$//g')
		MEJOR_JUEGO=$($PSQL "SELECT MIN(score) FROM games WHERE user_id=$USER_ID" | sed -E 's/^ *| *$//g')
		echo "Welcome back, $NAME! You have played $CANT_JUEGOS games, and your best game took $MEJOR_JUEGO guesses."
	fi
	ADIVINAR
	#inserto este juego en la base de datos
	INSERTAR=$($PSQL "INSERT INTO games(user_id, score) VALUES ($USER_ID, $CONTADOR)")
}

#veo si el usuario lo adivino
function ADIVINAR() {
	#incremento el contador que lleva la cantidad de juegos jugados
	((CONTADOR++))
	if [[ $1 ]]; then
		#si hay argumento
		if [[ ! $1 =~ ^[0-9]+$ ]]; then
			echo "No ingreso un numero, animal"
		else
			if [[ $1 > $RAND ]]; then
				echo "It's lower than that, guess again:"
			else
				echo "It's higher than that, guess again:"
			fi
		fi
	fi
	read NUMERO
	#si el usuario no ingresa nada, se termina el juego
	if [[ -z $NUMERO ]]; then 
		exit
	fi
	if [[ $NUMERO = $RAND ]]; then
		#si el usuario adivina, se da el mensaje y se termina la funcion
		echo "Lo has adivinado! Es $NUMERO, y lo has hecho en $CONTADOR intentos."
	else
		#en caso de no adivinar, se vuelve a llamar a la funcion con el numero como argumento para que se muestre el mensaje del principio de la funcion
		ADIVINAR $NUMERO
	fi
}
#el numero random es
RAND=$((1 + $RANDOM % 10))
#creo un contador que contabilizara la cantidad de juegos jugados
CONTADOR=0
MAIN
