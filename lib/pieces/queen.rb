require "./lib/pieces/pieces.rb"

class Queen < Pieces::Piece
	def search
		@moves = []
		(1..7).each { |n| @moves.push([n,0], [0,n], [-n,0], [0,-n], [-n,n], [-n,-n], [n,-n], [n,n]) }
		possible_moves
	end
end