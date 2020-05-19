import pygame
import os
import board

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


_image_library = {}
def get_image(path):
	global _image_library
	image = _image_library.get(path)
	if image == None:
		canonicalized_path = path.replace('/', os.sep).replace('\\', os.sep)
		image = pygame.image.load(canonicalized_path)
		_image_library[path] = image
	return image

pygame.init()
display = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT + 50))
current_board = board.STARTING_BOARD
done = False
clock = pygame.time.Clock()

while not done:
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			done = True
	display.fill(LIGHT_GREY)
	draw_grid(display)
	show_available_moves(display, 3, 0, current_board)
	draw_board(display, current_board)
	#display.blit(get_image('img/ball.png'), (20, 20))
	pygame.display.flip()
	clock.tick(60)
