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
		puts "#{current.color}, it is your turn."
		puts "Enter coordinates of piece you wish to move: "
		from = gets.chomp
		puts "Enter coordinates of where you wish to move #{from}: "
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

	def turn
		while true
			from, to = ask_user_choice
			if board.allowed?(from, to)
				board.update_piece(from, to)
				break
			else
				puts "You can't do that."
			end
		end
	end

	def play
		while true
			turn
			swap
		end
	end

end