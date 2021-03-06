PLAYER_1 = 3
PLAYER_2 = 2

ATTACKER = 'attacker'
DEFENDER = 'defender'
KING = 'king'
EMPTY = 'empty'

PIECES = {
	0: EMPTY,
	1: KING,
	2: DEFENDER,
	3: ATTACKER
	}

STARTING_BOARD = [
	[0,0,0,3,0,0,0],
	[0,0,0,3,0,0,0],
	[0,0,0,2,0,0,0],
	[3,3,2,1,2,3,3],
	[0,0,0,2,0,0,0],
	[0,0,0,3,0,0,0],
	[0,0,0,3,0,0,0]
	]

BOARD_SIZE = len(STARTING_BOARD)

ENEMY_RELATIONSHIP = {
	1: [3],
	2: [3],
	3: [1,2]
	}

THRONE = [3,3]
CORNERS = [[0,0],[0,6],[6,6],[6,0]]

#%% UTILS
def print_board(board):
	for row in range(BOARD_SIZE):
		line = ''
		for col in range(BOARD_SIZE):
			line = line + str(board[row][col]) + ' '
		print(line)

def select_piece(x,y, board):
	if x >= 0 and x < BOARD_SIZE and y >= 0 and y < BOARD_SIZE:
		return board[x][y]
	else:
		return None

def change_player(current_player):
	if current_player == PLAYER_1:
		return PLAYER_2
	else:
		return PLAYER_1

def missing_king(board):
	for x in range(len(board)):
		for y in range(len(board[x])):
			if board[x][y] == 1:
				return False
	return True

#%% MOVEMENT
def can_move(player, piece):
	if player == PLAYER_2 and (piece == 1 or piece == 2):
		return True
	elif player == PLAYER_1 and piece == 3:
		return True
	else:
		return False

def get_available_moves(x, y, board):
	available_moves = []
	if board[x][y] != 0:
		if y > 0:
			for l in range(y - 1, -1, -1):
				if select_piece(x, l, board) == 0:
					available_moves.append([x, l])
				else:
					break
		if x > 0:
			for u in range(x - 1, -1, -1):
				if select_piece(u, y, board) == 0:
					available_moves.append([u, y])
				else:
					break
		if y < len(board):
			for r in range(y + 1, len(board)):
				if select_piece(x, r, board) == 0:
					available_moves.append([x, r])
				else:
					break
		if x < len(board):
			for d in range(x + 1, len(board)):
				if select_piece(d, y, board) == 0:
					available_moves.append([d, y])
				else:
					break
		#now check if castle in the middle is included
		if THRONE in available_moves:
			available_moves.remove(THRONE)
		#if piece to move is different from king, remove corners too
		if board[x][y] != 1:
			for corner in CORNERS:
				if corner in available_moves:
					available_moves.remove(corner)
	return available_moves

def move_piece(x1, y1, x2, y2, board):
	piece1 = select_piece(x1,y1,board)
	piece2 = select_piece(x2,y2,board)
	board[x1][y1] = piece2
	board[x2][y2] = piece1
	return board

def change_player(current_player):
	if current_player == PLAYER_1:
		return PLAYER_2
	else:
		return PLAYER_1

#%% COMBAT
def is_enemy(piece1, piece2):
	if piece2 != 0:
		if piece2 in ENEMY_RELATIONSHIP[piece1]:
			return True
	return False

def is_ally(piece1, piece2):
	if piece2 != 0:
		if not piece2 in ENEMY_RELATIONSHIP[piece1]:
			return True
	return False

def check_for_enemies(piece, x, y, board):
	enemies = []
	if y > 0:
		left = board[x][y-1]
		if is_enemy(piece, left):
			enemies.append([x, y-1])
	if y < BOARD_SIZE - 1:
		right = board[x][y+1]
		if is_enemy(piece, right):
			enemies.append([x, y+1])
	if x > 0:
		up = board[x-1][y]
		if is_enemy(piece, up):
			enemies.append([x-1, y])
	if x < BOARD_SIZE - 1:
		down = board[x+1][y]
		if is_enemy(piece, down):
			enemies.append([x+1, y])
	return enemies

def fight(piece, piece_x, piece_y, enemies, board):
	for enemy_position in enemies:
		enemy_x = enemy_position[0]
		enemy_y = enemy_position[1]
		enemy_piece = board[enemy_x][enemy_y]
		delta_x = piece_x - enemy_x
		delta_y = piece_y - enemy_y
		#if enemy piece is not the king or, if it is the king, he must be positioned outside the throne
		if enemy_piece != 1 or (enemy_piece == 1 and (enemy_x != THRONE[0] or enemy_y != THRONE[1])):
			if (delta_y == 1 and enemy_y > 0 and (is_ally(piece, board[enemy_x][enemy_y - 1]) or is_hostile_cell_to_piece(board[enemy_x][enemy_y], enemy_x, enemy_y - 1, board))) or \
			(delta_y == -1 and enemy_y < BOARD_SIZE -1 and (is_ally(piece, board[enemy_x][enemy_y + 1]) or is_hostile_cell_to_piece(board[enemy_x][enemy_y], enemy_x, enemy_y + 1, board))) or \
			(delta_x == 1 and enemy_x > 0 and (is_ally(piece, board[enemy_x - 1][enemy_y]) or is_hostile_cell_to_piece(board[enemy_x][enemy_y], enemy_x - 1, enemy_y, board))) or \
			(delta_x == -1 and enemy_x < BOARD_SIZE - 1 and (is_ally(piece, board[enemy_x + 1][enemy_y]) or is_hostile_cell_to_piece(board[enemy_x][enemy_y], enemy_x + 1, enemy_y, board))):
				#print("\nENEMY KILLED!")
				board[enemy_x][enemy_y] = 0
		if enemy_piece == 1 and enemy_x == THRONE[0] and enemy_y == THRONE[1] and \
		board[enemy_x][enemy_y -1] == 3 and \
		board[enemy_x][enemy_y + 1] == 3 and \
		board[enemy_x - 1][enemy_y] == 3 and \
		board[enemy_x + 1][enemy_y] == 3:
			#print("\nKING CAPTURED!")
			board[enemy_x][enemy_y] = 0
	return board

def is_hostile_cell_to_piece(piece, cell_x, cell_y, board):
	if (cell_x == 0 and cell_y == 0) or \
	(cell_x == 0 and cell_y == 6) or \
	(cell_x == 6 and cell_y == 6) or \
	(cell_x == 6 and cell_y == 0) or\
	((cell_x == 3 and cell_y == 3) and piece == 3) or \
	((cell_x == 3 and cell_y == 3) and piece == 2 and board[cell_x][cell_y] == 0):
		return True
	return False

#%% INPUT MANAGEMENT
def choose_piece_position():
	selected_piece_position = eval(input("\nSelect the piece you want to move (you have to specify the position in the board, for example '[4,4]')\n"))
	if(len(selected_piece_position) != 2):
		print("\nPosition format not correct.")
		choose_piece_position()
	else:
		return selected_piece_position

def choose_destination_position(available_moves):
	print("The piece's available moves are: ")
	for move in available_moves:
		print(move)
	destination_position = eval(input("\nSelect the position you want the piece to move (you have to specify the position in the board, for example '[4,4]')\n"))
	if(len(destination_position) != 2):
		print("\nPosition format not correct.")
		return choose_destination_position(available_moves)
	elif not destination_position in available_moves:
		print("You can not move there")
		return choose_destination_position(available_moves)
	else:
		return destination_position

#%% GAME

def update_board(x1, y1, x2, y2, board):
	piece = board[x1][y1]
	board = move_piece(x1, y1, x2, y2, board)
	for x in range(len(board)):
		for y in range(len(board[x])):
			if ((piece == 2 or piece == 1) and (board[x][y] == 2 or board[x][y] == 1)) or \
			(piece == 3 and board[x][y] == 3):
				enemies = check_for_enemies(piece, x, y, board)
				if len(enemies) > 0:
					board = fight(piece, x, y, enemies, board)
	return board

def game_over(player, board):
	if (player == 2 and ((board[0][0] == 1) or (board[0][6] == 1) or (board[6][6] == 1) or (board[6][0] == 1))) or \
	(player == 3 and missing_king(board)):
		return True
	return False

#%% MAIN

def main():
	current_player = PLAYER_1
	current_board = STARTING_BOARD
	while True:
		print_board(current_board)
		print('\nIt\'s ' + current_player + '\'s turn.')
		selected_piece_position = choose_piece_position()
		piece_x = selected_piece_position[0]
		piece_y = selected_piece_position[1]
		piece = select_piece(piece_x, piece_y, current_board)
		if can_move(current_player, piece):
			available_moves = get_available_moves(piece_x, piece_y, current_board)
			if(len(available_moves) > 0):
				destination_position = choose_destination_position(available_moves)
				destination_x = destination_position[0]
				destination_y = destination_position[1]
				current_board = move_piece(piece_x, piece_y, destination_x, destination_y, current_board)
				#update coordinates
				piece_x = destination_x
				piece_y = destination_y
				enemies = check_for_enemies(piece, piece_x, piece_y, current_board)
				if len(enemies) > 0:
					current_board = fight(piece, piece_x, piece_y, enemies, current_board)
				current_player = change_player(current_player)
			else:
				print("The piece you selected can not permorm any type of move. Please, select another one.\n")
		else:
			print("You cannot select an enemy's piece. Please, select another one.\n")

if __name__ == "__main__":
   main()
