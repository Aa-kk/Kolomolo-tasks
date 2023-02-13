# Hanoi Towers Game 
This folder contains the solution to the Hanoi Towers game and some sample input files.

## How it works 
When the game is run, it asks the user to type the name of the file which 
contains the user's input as described in the [question](https://github.com/alexkolomolo/nodejstest/tree/master/programming_task). 
The app reads the file, parses all the input into a list of tuples, and uses the first tuple to create a gamestate using embedded lists.  

The app simulates the player's moves using the remaining set of input as moves by moving the last item from a list which represents a tower to the other list/tower and runs a check after every move to see if the user has either lost or won the game.


### Requirements
The input files have to be in the same directory as the game.py file.