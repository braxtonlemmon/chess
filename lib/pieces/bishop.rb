require "./lib/pieces/pieces.rb"

class Bishop < Pieces::Piece 
	def initialize(rank, file)
		super
		@symbol = @color == "White" ? "\u265D".encode('utf-8') : "\u2657".encode('utf-8')
	end
	
	def search
		@moves = []
		(1..7).each { |n| @moves.push([-n,n], [-n,-n], [n,-n], [n,n]) }
		possible_moves
	end
end