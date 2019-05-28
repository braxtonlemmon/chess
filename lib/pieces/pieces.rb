module Pieces
	class Piece
		attr_accessor :color, :rank, :file, :moves, :symbol

		def initialize(rank, file, color=nil)
			@rank = rank
			@file = file
			@color = color == nil ? define_color : color
		end

		def define_color
			@rank < 2 ? "Black" : "White"
		end

		def ok_move?(distance)
			result = [(rank + distance[0]), (file + distance[1])]
			result[0].between?(0,7) && result[1].between?(0,7) ? true : false
		end

		def possible_moves
			possible_moves = @moves.select { |move| ok_move?(move) }
			possible_moves.map { |move| [rank + move[0], file + move[1]] }
		end
	end
end
