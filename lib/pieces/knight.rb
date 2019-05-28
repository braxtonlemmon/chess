require "./lib/pieces/pieces.rb"

class Knight < Pieces::Piece 
	def initialize(rank, file, color=nil)
		super
		@symbol = @color == "White" ? "\u265E".encode('utf-8') : "\u2658".encode('utf-8')
	end

	def search
		@moves = [[-2,-1], [-2,1], [-1,-2], [-1,2], [1,-2], [1,2], [2,-1], [2,1]]
		possible_moves
	end
end