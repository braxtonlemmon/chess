require "./lib/board.rb"
require "./lib/player.rb"

class Game
	attr_reader :white, :black, :current, :board

	def initialize
		@white = Player.new
		@black = Player.new
		@current = @white
		@board = Board.new
	end

	def ask_user_choice
		puts "#{current.color}, enter coordinates of piece to move: "
		from = gets.chomp
		puts "Enter coordinates of where to move #{from}: "
		to = gets.chomp
		[convert(from), convert(to)]
	end

	def convert(spot)
		spot = spot.split("")
		char = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6,	"h" => 7, 
						 "8" => 0, "7" => 1, "6" => 2, "5" => 3, "4" => 4, "3" => 5, "2" => 6,	"1" => 7 }
		[char[spot[1]], char[spot[0]]]
	end

	def swap
		@current = @current.color == "White" ? @black : @white
	end

	def color_ok?(from)
		@board.grid[from[0]][from[1]].color == @current.color ? true : false
	end

	def locate_king
		board.grid.flatten.find do |square| 
			square.class == King && square.color == current.color 
		end
	end

	def check?
		king = locate_king
		board.grid.flatten.any? do |piece|
			if piece.class != String && piece.color != king.color
				board.allowed?([piece.rank, piece.file], [king.rank, king.file])
			end
		end
	end

	def turn
		while true
			from, to = ask_user_choice
			if color_ok?(from) && board.allowed?(from, to)
				board.update_piece(from, to)
				board.show
				break
			else
				board.show
				puts "You can't do that."
			end
		end
	end

	def play
		board.show
		while true
			turn
			swap
		end
	end

end