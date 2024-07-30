DROP DATABASE IF EXISTS number_guessing;
CREATE DATABASE number_guessing;

\c number_guessing

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	user_id SERIAL NOT NULL PRIMARY KEY,
	user_name VARCHAR(22)
);

CREATE TABLE games (
	game_id SERIAL NOT NULL PRIMARY KEY,
	user_id INT REFERENCES users(user_id),
	score INT
);
