require "./lib/board.rb"
require "./lib/player.rb"

class Game
	attr_reader :white, :black, :current, :board

	def initialize
		
		@white = Player.new("White")
		@black = Player.new("Black")
		@current = @white
		@board = Board.new
	end

	def ask_user_choice
		board.show
		from = ""
		to = ""
		until (from[0] =~ /[a-h]/) && (from[1] =~ /[1-8]/) && from.length == 2
			puts "#{current.color}, enter coordinates of piece to move: "
			from = gets.chomp
		end
		until (to[0] =~ /[a-h]/) && (to[1] =~ /[1-8]/) && to.length == 2
			puts "Enter coordinates of where to move #{from}: "
			to = gets.chomp
		end
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
			piece = board.locate(from)
			if color_ok?(from) && piece.possible_moves(board).include?(to) && !check?(from, to)
				move(from, to)
				@board.last = [from, to]
				break
			end
			puts "You can't do that."
		end
	end

	def play
		while true
			board.show
			turn
			swap
		end
	end

	def color_ok?(from)
		square = board.grid[from[0]][from[1]]
		(square != " " && square.color == @current.color) ? true : false
	end

	def move(from, to)
		piece = board.locate(from)
		if piece.class == King
			(from[1] - to[1]).abs == 2 ? board.castle(from, to) : board.update_piece(from, to)
		elsif piece.class == Pawn
			if piece.can_passant?(to, @board)
				board.en_passant(from, to, piece)
			elsif promotion?(from, to)
				board.promote(from, to)
			else 
				board.update_piece(from, to)
			end
		else
			board.update_piece(from, to)
		end
	end
	
	def copy_board
		@copy = Marshal.load(Marshal.dump(@board))
	end

	def check?(from, to)
		copy = Marshal.load(Marshal.dump(@board))
		copy.update_piece(from, to)
		copy.under_attack?(copy.locate_king(current.color))
	end

	def promotion?(from, to)
		pawn = board.grid[from[0]][from[1]]
		return false unless pawn.class == Pawn
		return true if pawn.color == "White" && to[0] == 0
		return true if pawn.color == "Black" && to[0] == 7
	end
end

