from pyswip import Prolog
import board

FILE = '../pl/tablut.pl'
prolog = Prolog()
prolog.consult(FILE)

def from_board_to_string(board):
    s = '['
    for x in range(len(board)):
        s = s + '['
        for y in range(len(board[x])):
            if board[x][y] == 0:
                piece = 'e'
            elif board[x][y] == 1:
                piece = 'k'
            elif board[x][y] == 2:
                piece = 'd'
            else:
                piece = 'a'
            s = s + piece + ','
        #remove last ','
        s = s[:-1] + '],'
    #remove last ','
    s = s[:-1] + ']'
    return s

def choose_move(board, player):
    if player == 2:
        player_string = 'd'
    else:
        player_string = 'a'
    query = 'choose_best_move(' + player_string + ',' + from_board_to_string(board) + ',1,M)'
    query_result = list(prolog.query(query))
    return query_result[0]['M'][0]