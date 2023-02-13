# Reading the input file and passing the data into a list of tuples 
def read_input():
    input_file = input("Welcome to the Hanoi Towers game please insert the name of your input file: ")
    f = open(input_file, "r")        
    data = []
    for line in f:
        data.append(line.strip().split())
    for i in range(len(data)):
        data[i] = (int(data[i][0]), int(data[i][1]))
    f.close()
    return data  


# Setting the gamestate
data = read_input()
print(data)
no_of_discs = data[0][0]        
no_of_towers = data[0][1]
print(f"You decided to start with {no_of_towers} towers and {no_of_discs} discs") 


# creating a list of towers(lists)
def creating_towers(n,d):
    game = []
    for i in range(n):
        game.append([])    # Adding a list for each tower 
    for i in range(1, d+1):
        game[0].append(i)   # Adding integars for each disc
    return game

init_list_of_towers = creating_towers(no_of_towers,no_of_discs)
list_of_towers = creating_towers(no_of_towers,no_of_discs)

print(f"The initial gamestate looks like this {init_list_of_towers} after adding {no_of_discs} discs to the first tower ")
init_start_tower = init_list_of_towers[0]


def make_move(list_of_towers, data, l):
    print(f"index of the current moves is: {l}")      # checking the index of the tuple carrying the moves to make
    print(f"Remember at this point the game looks like this {list_of_towers}")         
    
    start_tower_index = (data[l][0] - 1)
    end_tower_index = (data[l][1] -1)
    start_tower = (list_of_towers[start_tower_index])
    end_tower = (list_of_towers[end_tower_index])

    print(f"we are moving the last disc from {start_tower} to {end_tower}")  
    
    index_of_disc = len(list_of_towers[start_tower_index])-1
    disc = list_of_towers[start_tower_index][index_of_disc]  # Picking the last value of the start tower
    list_of_towers[end_tower_index].append(disc)     # Adding the last disc from start to the specified tower 
    list_of_towers[start_tower_index].pop()          # Deleting the disc from start tower
    print(f"Gamestate after the move {l} is {list_of_towers} final tower looks like {end_tower} while it should look like {init_start_tower}")

    return end_tower


class GameOver(Exception):
    pass

def test_move(init_start_tower, end_tower):
    if len(end_tower) >= 2:
        new_disc = end_tower[-1]
        last_disc = end_tower[-2]

        if init_start_tower == end_tower:
            raise GameOver("You win !!!, you finished the game !!!")
        if new_disc < last_disc:
            raise GameOver("Illegal move !!!, you have failed the game")



def main():
    
    for l in range(1, len(data)):
        end_tower = make_move(list_of_towers, data, l)
        try:
            test_move(init_start_tower, end_tower)
        except GameOver as message:
            print(message)
            break

if __name__ == "__main__":
    main()