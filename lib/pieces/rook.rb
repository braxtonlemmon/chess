require "./lib/pieces/pieces.rb"

class Rook < Pieces::Piece
	def search
		@moves = []
		(1..7).each { |n| @moves.push([n,0], [0,n], [-n,0], [0,-n]) }
		possible_moves
	end
end

