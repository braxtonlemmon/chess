require "./lib/pieces/pieces.rb"

class Bishop < Pieces::Piece 
	def search
		@moves = []
		(1..7).each { |n| @moves.push([-n,n], [-n,-n], [n,-n], [n,n]) }
		possible_moves
	end
end