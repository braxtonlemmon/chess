require "./lib/pieces/pieces.rb"
require "./lib/board.rb"

class Rook < Piece
	attr_accessor :traveled
	
	def initialize(rank, file, color=nil)
		super
		@traveled = false
		@symbol = @color == "White" ? "\u265C".encode('utf-8') : "\u2656".encode('utf-8')
		@moves = []
		(1..7).each { |n| @moves.push([n,0], [0,n], [-n,0], [0,-n]) }
	end
end

