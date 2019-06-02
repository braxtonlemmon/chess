require "./lib/pieces/pieces.rb"
require "./lib/board.rb"

class Knight < Piece 
	def initialize(rank, file, color=nil)
		super
		@symbol = @color == "White" ? "\u265E".encode('utf-8') : "\u2658".encode('utf-8')
		@moves = [[-2,-1], [-2,1], [-1,-2], [-1,2], [1,-2], [1,2], [2,-1], [2,1]]
	end
end