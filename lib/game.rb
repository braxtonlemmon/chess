require "./lib/board.rb"
require "./lib/player.rb"

class Game
	attr_reader :white, :black, :current, :board, :last

	def initialize
		
		@white = Player.new("White")
		@black = Player.new("Black")
		@current = @white
		@board = Board.new
		@last = [[0,0], [0,0]]
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
			if determine_move(from, to)
				@last = [from, to]
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

	def determine_move(from, to)
		piece = board.grid[from[0]][from[1]]
		target = board.grid[to[0]][to[1]]
		
		row = (from[0] - to[0]).abs
		col = (from[1] - to[1]).abs
		case true
		when piece.class == King && col == 2
			board.castle(from, to) if can_castle?(from, to)
		when piece.class == Pawn 
			if (row == 1 && col == 1 && target != " ") || (board.allowed?(from, to) && target == " ")
				promotion?(from, to) ? board.promote(from, to) : board.update_piece(from, to)
			elsif row == 1 && col == 1 && target == " " && can_passant?(piece, to)
				board.en_passant(from, to, piece)
			end
		when board.allowed?(from, to) && color_ok?(from)
			board.update_piece(from, to)
		else
			false
		end
	end

	def under_attack?(spot)
		board.grid.any? do |row|
			row.any? do |piece|
				board.allowed?([piece.rank, piece.file], spot) if piece.class != String && piece.color != current.color
			end
		end
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

	def promotion?(from, to)
		pawn = board.grid[from[0]][from[1]]
		return false unless pawn.class == Pawn
		return true if pawn.color == "White" && to[0] == 0
		return true if pawn.color == "Black" && to[0] == 7
	end

	def can_passant?(piece, to)
		return false unless @last[0] == [to[0]-1, to[1]]
		passant = (piece.color == "White") ? board.grid[to[0]+1][to[1]] : board.grid[to[0]-1][to[1]]
		passant != " " && (passant.color != piece.color) ? true : false
	end

	def can_attack?(piece, to)
		if piece.color == "White" && piece.rank - to[0] == 1 
			return true if (piece.file - to[1]).abs == 1 && !board.spot_empty?(to[0], to[1])
		elsif piece.color == "Black" && piece.rank - to[0] == -1
			return true if (piece.file - to[1]).abs == 1 && !board.spot_empty?(to[0], to[1])
		end
		false
	end

	def legal_moves(rank, file)
		piece = board.grid[rank][file]
		moves = piece.search.select { |to| to if board.allowed?([rank, file], to) }
		if piece.class == King
			[-2, 2].each { |i| moves << [rank, file+i] if can_castle?([rank, file], [rank, file+i]) }
		elsif piece.class == Pawn
			[[-1,-1], [-1,1], [1,1], [1,-1]].each do |to|
				moves << [rank+to[0], file+to[1]] if can_attack?(piece, [rank+to[0], file+to[1]])
				moves << [rank+to[0], file+to[1]] if can_passant?(piece, [rank+to[0], file+to[1]])
			end
		end
		moves 
	end

end

