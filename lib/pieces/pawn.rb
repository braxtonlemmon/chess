require "./lib/pieces/pieces.rb"
require "./lib/board.rb"

class Pawn < Piece
	attr_accessor :plays

	def initialize(rank, file, color=nil)
		super
		@symbol = @color == "White" ? "\u265F".encode('utf-8') : "\u2659".encode('utf-8')
	end

	def moves
		if @color == "White"
			@moves = (@rank == 6 ? [[-1,0], [-2,0]] : [[-1,0]])
		elsif @color == "Black"
			@moves = (@rank == 1 ? [[1, 0], [2, 0]] : [[1, 0]])
		end
	end

	def possible_moves(board)
		moves
		super
		@plays.delete_if { |ahead| !board.spot_empty?(ahead[0], ahead[1]) }
		[[-1,-1], [-1,1], [1,1], [1,-1]].each do |to|
			move = [rank + to[0], file + to[1]]
			@plays << move if on_board?(to) && can_attack?(move, board)
			@plays << move if on_board?(to) && can_passant?(move, board)
		end
		@plays
	end

	def can_passant?(move, board)
		passant = board.grid[rank][move[1]] 
		if @color == "White" && (rank - move[0] == 1)
			return false unless board.last[0] == [move[0]-1, move[1]]
		elsif (rank - move[0] == -1)
			return false unless board.last[0] == [move[0]+1, move[1]]
		end
		(passant != " ") && (passant.color != @color) ? true : false
	end

	def can_attack?(to, board)
		if @color == "White" && @rank - to[0] == 1 
			return true if (@file - to[1]).abs == 1 && !board.spot_empty?(to[0], to[1])
		elsif @color == "Black" && @rank - to[0] == -1
			return true if (@file - to[1]).abs == 1 && !board.spot_empty?(to[0], to[1])
		end
		false
	end
end
