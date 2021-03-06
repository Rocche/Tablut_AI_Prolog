import pygame
import os
import board
import ai_handler
import asyncio

HUMAN_PLAYER = 2
AI_PLAYER = 3

SCREEN_WIDTH = 700
SCREEN_HEIGHT = 700
CELL_DIMENSION = 100

WHITE = (255,255,255)
BLACK = (0,0,0)
RED = (255,0,0)
GREEN = (0,255,0)
GRASS_GREEN = (51,204,51)
BLUE = (0,0,255)
BROWN = (153,102,51)
LIGHT_GREY = (224,224,209)
GREY = (153,153,102)
HIGHLIGHT_YELLOW = (255,255,102)

def draw_board(display, current_board):
	for row_index in range(len(current_board)):
		for col_index in range(len(current_board[row_index])):
			cell = current_board[row_index][col_index]
			if(cell != 0):
				draw_piece(display, cell, row_index, col_index)

def draw_grid(display):
	for x in range(0, SCREEN_HEIGHT, CELL_DIMENSION):
		for y in range(0, SCREEN_WIDTH, CELL_DIMENSION):
			if x == CELL_DIMENSION * 3 and y == CELL_DIMENSION * 3:
				pygame.draw.rect(display, BROWN, (y, x, CELL_DIMENSION, CELL_DIMENSION))
			elif (x == CELL_DIMENSION * 0 and y == CELL_DIMENSION * 0) or \
			(x == CELL_DIMENSION * 0 and y == CELL_DIMENSION * 6) or \
			(x == CELL_DIMENSION * 6 and y == CELL_DIMENSION * 6) or \
			(x == CELL_DIMENSION * 6 and y == CELL_DIMENSION * 0): 
				pygame.draw.rect(display, GRASS_GREEN, (y, x, CELL_DIMENSION, CELL_DIMENSION))
			pygame.draw.rect(display, BLACK, (y, x, CELL_DIMENSION, CELL_DIMENSION),4)

def draw_circle_in_cell(display, x, y, radius, color, with_border):
	x_center = x * CELL_DIMENSION + CELL_DIMENSION // 2
	y_center = y * CELL_DIMENSION + CELL_DIMENSION // 2
	pygame.draw.circle(display, color, (y_center,x_center), radius)
	if with_border:
		pygame.draw.circle(display, BLACK, (y_center,x_center), radius, 4)

def draw_piece(display, piece, row, col):
	if piece == 1:
		color = RED
	elif piece == 2:
		color = BLUE
	elif piece == 3:
		color = BLACK
	draw_circle_in_cell(display, row, col, CELL_DIMENSION // 2 - 10, color, True)

def highlight_cell(display, x, y):
	pygame.draw.rect(display, HIGHLIGHT_YELLOW, (y * CELL_DIMENSION, x * CELL_DIMENSION, CELL_DIMENSION, CELL_DIMENSION))
	pygame.draw.rect(display, BLACK, (y * CELL_DIMENSION, x * CELL_DIMENSION, CELL_DIMENSION, CELL_DIMENSION),4)
	draw_circle_in_cell(display, x, y, CELL_DIMENSION // 6, GREY, False)

def show_available_moves(display, x, y, current_board):
	cells = board.get_available_moves(x, y, current_board)
	for cell in cells:
		highlight_cell(display, cell[0], cell[1])

def from_mouse_position_to_coordinates(position):
	return [position[1] // CELL_DIMENSION, position[0] // CELL_DIMENSION]

def change_player(current_player):
	if current_player == 2:
		return 3
	else:
		return 2

def text_objects(text, font, color):
    textSurface = font.render(text, True, color)
    return textSurface, textSurface.get_rect()

def game_over_screen(display, winning_player):
	if winning_player == 2:
		text = "Defenders won!"
		color = BLUE
	else:
		text = "Attackers won!"
		color = BLACK
	largeText = pygame.font.Font('freesansbold.ttf',80)
	TextSurf, TextRect = text_objects(text, largeText, color)
	TextRect.center = ((SCREEN_WIDTH/2),(SCREEN_HEIGHT/2))
	display.blit(TextSurf, TextRect)

async def main():
	pygame.init()
	display = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT + 50))
	current_board = board.STARTING_BOARD
	done = False
	game_over = False
	clock = pygame.time.Clock()

	mouse_position = None
	selected_piece_coords = None
	current_player = 3

	while not done:
		if current_player == HUMAN_PLAYER:
			for event in pygame.event.get():
				if event.type == pygame.QUIT:
					done = True
				if event.type == pygame.MOUSEBUTTONUP:
					mouse_position = pygame.mouse.get_pos()
			display.fill(LIGHT_GREY)
			draw_grid(display)
			if mouse_position != None and selected_piece_coords == None:
				selected_piece_coords = from_mouse_position_to_coordinates(mouse_position)
				if board.can_move(current_player, current_board[selected_piece_coords[0]][selected_piece_coords[1]]):
					show_available_moves(display, selected_piece_coords[0], selected_piece_coords[1], current_board)
				else:
					selected_piece_coords = None
				mouse_position = None
			elif mouse_position == None and selected_piece_coords != None:
				show_available_moves(display, selected_piece_coords[0], selected_piece_coords[1], current_board)
			elif mouse_position != None and selected_piece_coords != None:
				movement_coords = from_mouse_position_to_coordinates(mouse_position)
				if movement_coords in board.get_available_moves(selected_piece_coords[0], selected_piece_coords[1], current_board):
					current_board = board.update_board(selected_piece_coords[0], selected_piece_coords[1], movement_coords[0], movement_coords[1], current_board)
					if board.game_over(current_player, current_board):
						game_over_screen(display, current_player)
						done = True
					else:
						current_player = change_player(current_player)
				mouse_position = None
				selected_piece_coords = None
			draw_board(display, current_board)
			pygame.display.flip()
			clock.tick(60)
		else:
			move = await ai_handler.choose_move(current_board, current_player)
			from_cell = move[0]
			to_cell = move[1]
			current_board = board.update_board(from_cell[0], from_cell[1], to_cell[0], to_cell[1], current_board)
			if board.game_over(current_player, current_board):
				game_over_screen(display, current_player)
				done = True
			else:
				current_player = change_player(current_player)
			draw_board(display, current_board)
			pygame.display.flip()
			clock.tick(60)

asyncio.run(main())