#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do 
  if [[ $YEAR != "year" ]]
  then   
    # TEAMS table
    #GET TEAM_ID
    WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")
    # IF NOT FOUND
    if [[ -z $WINNER_ID ]]
    then
      #insert
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      #new 
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert 
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      # new 
      OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
    fi
  
    # GAMES TABLE
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS )")
        
    echo $INSERT_GAME  
  fi 
done
