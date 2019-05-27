require "./lib/pieces/pieces.rb"

class King < Pieces::Piece 
	attr_accessor :traveled

	def initialize(rank, file)
		super
		@traveled = false
		@symbol = @color == "White" ? "\u265A".encode('utf-8') : "\u2654".encode('utf-8')
	end

	def search
		@moves = [[-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1]]
		@moves.push([0,2], [0,-2]) unless @traveled
		possible_moves
	end

end