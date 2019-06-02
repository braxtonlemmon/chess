require "./lib/pieces/pieces.rb"
require "./lib/board.rb"

class Queen < Piece
	def initialize(rank, file, color=nil)
		super
		@symbol = @color == "White" ? "\u265B".encode('utf-8') : "\u2655".encode('utf-8')
		@moves = []
		(1..7).each { |n| @moves.push([n,0], [0,n], [-n,0], [0,-n], [-n,n], [-n,-n], [n,-n], [n,n]) }
	end
end