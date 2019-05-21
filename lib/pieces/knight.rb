require "./lib/pieces/pieces.rb"

class Knight < Pieces::Piece 
	def search
		@moves = [[-2,-1], [-2,1], [-1,-2], [-1,2], [1,-2], [1,2], [2,-1], [2,1]]
		possible_moves
	end
end