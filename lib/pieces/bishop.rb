require "./lib/pieces/pieces.rb"
require "./lib/board.rb"

class Bishop < Piece 
	def initialize(rank, file, color=nil)
		super
		@symbol = @color == "White" ? "\u265D".encode('utf-8') : "\u2657".encode('utf-8')
		@moves = []
		(1..7).each { |n| @moves.push([-n,n], [-n,-n], [n,-n], [n,n]) }
	end
end