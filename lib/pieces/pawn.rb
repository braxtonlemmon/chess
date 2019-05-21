require "./lib/pieces/pieces.rb"

class Pawn < Pieces::Piece
	def initialize(rank, file)
		super
		@symbol = @color == "White" ? "\u265F".encode('utf-8') : "\u2659".encode('utf-8')
	end

	def search
		if @color == "White"
			@moves = (@rank == 6 ? [[-1,0], [-2,0]] : [[-1,0]])
		elsif @color == "Black"
			@moves = (@rank == 1 ? [[1, 0], [2, 0]] : [[1, 0]])
		end
		possible_moves
	end
end
