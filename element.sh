#!/bin/bash
# Periodic Table Element Query Script - queries database for element information


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Check if input is a number (atomic number)
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $1")
# Check if input is 1-2 characters (symbol)
elif [[ ${#1} -le 2 ]]
then
  ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.symbol = '$1'")
# Otherwise treat as name
else
  ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.name = '$1'")
fi

if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
else
  echo $ELEMENT_INFO | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
# User login logic added
# Guessing loop logic added
# Input validation improvements
# User stats update logic
# Database schema setup:
# CREATE TABLE users (
#   user_id SERIAL PRIMARY KEY,
#   username VARCHAR(22) UNIQUE NOT NULL,
#   games_played INT DEFAULT 0,
#   best_game INT
# );

