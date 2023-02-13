# Reading the input file and passing the data into a list of tuples 
def read_input():
    input_file = input("Welcome to the Hanoi Towers game please insert the name of your input file: ")
    f = open(input_file, "r")        
    game_data = []
    for line in f:
        game_data.append(line.strip().split())
    for i in range(len(game_data)):
        game_data[i] = (int(game_data[i][0]), int(game_data[i][1]))
    f.close()
    return game_data  


# creating a list of towers(lists)
def creating_towers(no_of_towers,no_of_discs):
    game = []
    for i in range(no_of_towers):
        game.append([])    # Adding a list for each tower 
    for i in range(1, no_of_discs+1):
        game[0].append(i)   # Adding integars for each disc
    return game


def make_move(list_of_towers, data, current_move, init_start_tower):
    print(f"index of the current moves is: {current_move}")      # checking the index of the tuple carrying the moves to make
    print(f"Remember at this point the game looks like this {list_of_towers}")         
    
    start_tower_index = (data[current_move][0] - 1)
    end_tower_index = (data[current_move][1] -1)
    start_tower = (list_of_towers[start_tower_index])
    end_tower = (list_of_towers[end_tower_index])

    print(f"we are moving the last disc from {start_tower} to {end_tower}")  
    
    index_of_disc = len(list_of_towers[start_tower_index])-1
    disc = list_of_towers[start_tower_index][index_of_disc]  # Picking the last value of the start tower
    list_of_towers[end_tower_index].append(disc)     # Adding the last disc from start to the specified tower 
    list_of_towers[start_tower_index].pop()          # Deleting the disc from start tower
    print(f"Gamestate after the move {current_move} is {list_of_towers} final tower looks like {end_tower} while it should look like {init_start_tower}")

    return end_tower


class GameOver(Exception):
    pass

def test_move(init_start_tower, end_tower, current_move):
    if len(end_tower) >= 2:
        new_disc = end_tower[-1]
        last_disc = end_tower[-2]

        if init_start_tower == end_tower:
            raise GameOver(f"You win !!!, you finished the game with {current_move} moves !!!")
        if new_disc < last_disc:
            raise GameOver(f"Illegal move after move {current_move}!!!, you have failed the game")



def main():
    # Setting the gamestate
    game_data = read_input()
    print(game_data)
    no_of_discs = game_data[0][0]        
    no_of_towers = game_data[0][1]
    print(f"You decided to start with {no_of_towers} towers and {no_of_discs} discs") 

    init_list_of_towers = creating_towers(no_of_towers,no_of_discs)
    list_of_towers = creating_towers(no_of_towers,no_of_discs)

    print(f"The initial gamestate looks like this {init_list_of_towers} after adding {no_of_discs} discs to the first tower ")
    init_start_tower = init_list_of_towers[0]

    for current_move in range(1, len(game_data)):
        end_tower = make_move(list_of_towers, game_data, current_move, init_start_tower)
        try:
            test_move(init_start_tower, end_tower, current_move)
        except GameOver as message:
            print(message)
            break

if __name__ == "__main__":
    main()