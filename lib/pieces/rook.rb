require "./lib/pieces/pieces.rb"

class Rook < Pieces::Piece
	def initialize(rank, file)
		super
		@symbol = @color == "White" ? "\u265C".encode('utf-8') : "\u2656".encode('utf-8')
	end

	def search
		@moves = []
		(1..7).each { |n| @moves.push([n,0], [0,n], [-n,0], [0,-n]) }
		possible_moves
	end
end

