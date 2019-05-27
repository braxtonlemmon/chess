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

	def locate_king
		king = board.grid.flatten.find do |square| 
			square.class == King && square.color == current.color 
		end
		[king.rank, king.file]
	end

	def check?
		under_attack?(locate_king)
	end

	def under_attack?(spot)
		board.grid.any? do |row|
			row.any? do |piece|
				board.allowed?([piece.rank, piece.file], spot) if piece.class != String && piece.color != current.color
			end
		end
	end

	def can_castle?(from, to)
		files  = to[1] == 6 ? (4..7)     : (0..4)
		corner = to[1] == 6 ? [to[0], 7] : [to[0], 0]	
		king = board.grid[from[0]][from[1]]
		rook = board.grid[corner[0]][corner[1]]
		return false if king.traveled || rook.traveled
		return false unless board.path_clear?(from, corner)
		return false if files.any? { |file| under_attack?([from[0], file]) }
		true
	end

	def castle(from, to)
		corner = to[1] == 6 ? [to[0], 7] : [to[0], 0]
		inward = to[1] == 6 ? [to[0], 5] : [to[0], 3]
		board.update_piece(from, to)
		board.update_piece(corner, inward)
	end

	def color_ok?(from)
		@board.grid[from[0]][from[1]].color == @current.color ? true : false
	end

	def turn
		while true
			board.show
			from, to = ask_user_choice
			if board.allowed?(from, to) && color_ok?(from)
				determine_move(from, to)
				break
			else
				board.show
				puts "You can't do that."
			end
		end
	end

	def play
		while true
			board.show
			turn
			swap
		end
	end

	def determine_move(from, to)
		piece = board.grid[from[0]][from[1]]
		if piece.class == King && ((from[1]-to[1])**2) == 4
			castle(from, to) if can_castle?(from, to)
		elsif piece.class == Pawn 
		# 	en_passant
		# 	promotion
		# 	pawn_attack
			board.update_piece(from, to)
		else
			board.update_piece(from, to)
		end
	end



end