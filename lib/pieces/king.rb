require "./lib/pieces/pieces.rb"
require "./lib/board.rb"

class King < Piece 
	attr_accessor :traveled

	def initialize(rank, file, color=nil)
		super
		@traveled = false
		@symbol = @color == "White" ? "\u265A".encode('utf-8') : "\u2654".encode('utf-8')
		@moves = [[-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1]]
	end

	def possible_moves(board)
		super
		@plays << [@rank, 2] if can_castle?([@rank, 2], board)
		@plays << [@rank, 6] if can_castle?([@rank, 6], board)
		@plays
	end

	def can_castle?(to, board)
		files  = to[1] == 6 ? (4..7)     : (0..4)
		corner = to[1] == 6 ? [to[0], 7] : [to[0], 0]	
		rook = board.grid[corner[0]][corner[1]]
		return false unless rook.class == Rook
		return false if @traveled || rook.traveled
		return false unless board.path_clear?([rank,file], corner)
		true
	end
end