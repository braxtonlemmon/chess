require "./lib/board.rb"

class Piece
	attr_accessor :color, :rank, :file, :moves, :symbol, :plays

	def initialize(rank, file, color=nil)
		@rank = rank
		@file = file
		@color = color == nil ? define_color : color
	end

	def define_color
		@rank < 2 ? "Black" : "White"
	end

	def on_board?(move)
		result = [(rank + move[0]), (file + move[1])]
		result[0].between?(0,7) && result[1].between?(0,7) ? true : false
	end

	def possible_moves(board)
		@plays = @moves.select { |move| on_board?(move) }
		@plays.map! { |move| [rank + move[0], file + move[1]] }
		@plays = @plays.select { |to| board.allowed?([rank, file], to) }
	end
end

