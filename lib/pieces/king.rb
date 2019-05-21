require "./lib/pieces/pieces.rb"

class King < Pieces::Piece 
	attr_accessor :traveled

	def initialize(rank, file)
		super
		@traveled = false
	end

	def search
		@moves = [[-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1]]
		@moves.push([0,2], [0,-2]) unless @traveled
		possible_moves
	end
end