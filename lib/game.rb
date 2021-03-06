#!/home/braxton/.rbenv/shims/ruby

require "./lib/board.rb"
require "./lib/player.rb"
require "yaml"

class Game
	attr_reader :white, :black, :current, :board, :filename, :ai

	def initialize
		@ai = false
		@filename = nil
		@white = Player.new("White")
		@black = Player.new("Black")
		@current = @white
		@board = Board.new
	end

	def setup
		puts "Welcome to Chess! Enter [y] to load a saved game or any other key for a new game."
		puts "Then press Enter to continue."
		gets.chomp.downcase[0] == 'y' ? load_game : (puts "Starting new game...")
		puts "Would you (White) like to play against the computer (Black)? [y] [n]"
		puts "Then press Enter to continue."
		@ai = (gets.chomp.downcase[0] == 'y') ? true : false
		play
	end

	private

	def ask_user_choice
		from = ""
		to = ""
		until (from[0] =~ /[a-h]/) && (from[1] =~ /[1-8]/) && from.length == 2
			board.show
			puts "   [s]...save and quit        [x]...quit without saving"
			puts "#{current.color}, enter coordinates of piece to move (\"d2\" for example):"
			from = gets.chomp
			save_game if from.downcase[0] == "s"
			exit if from.downcase[0] == "x"
		end

		until (to[0] =~ /[a-h]/) && (to[1] =~ /[1-8]/) && to.length == 2
			puts "Enter coordinates of where to move #{from}: "
			to = gets.chomp
		end
		[convert(from), convert(to)]
	end

	def color_ok?(from)
		square = board.grid[from[0]][from[1]]
		(square != " " && square.color == @current.color) ? true : false
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
			puts "\n\n|********************|"
			puts "| You can't do that! |"
			puts "|____________________|"
		end
	end

	def ai_turn
		while true
			from, to = gen_random_move
			if !check?(from, to)
				move(from, to)
				@board.last = [from, to]
				puts "Computer move: #{ai_convert(from)} to #{ai_convert(to)}"
				break
			end
		end
	end

	def gen_random_move
		pieces = board.grid.flatten.select do |x|
			x.class != String && x.color == current.color && x.possible_moves(board).size > 0
		end
		piece = pieces.sample
		move = piece.possible_moves(board).sample	
		[[piece.rank, piece.file], move]
	end

	def play
		until checkmate?
			(@ai && @current.color == "Black") ? ai_turn : turn
			swap
		end
		board.show
		game_over
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

	def select_file
		while true
			puts "Please select a game file: (1) (2) (3)"
			@filename = gets.chomp
			break if filename.match?(/[123]/)
		end
	end

	def save_game
		Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
		select_file if filename.nil?

		File.open("saved_games/#{filename}.yaml", "w") do |file|
			save = YAML::dump({
				white: @white,
				black: @black,
				current: @current,
				board: @board,
				filename: @filename,
				ai: @ai
			})
			file.puts save
		end

		puts "Saving..."
		sleep(2)
		exit 
	end

	def load_game
		select_file
		if File.exist? "saved_games/#{filename}.yaml"
			saved_info = YAML::load File.read("saved_games/#{filename}.yaml")
			@white = saved_info[:white]
			@black = saved_info[:black]
			@current = saved_info[:current]
			@board = saved_info[:board]
			@filename = saved_info[:filename]
			@ai = saved_info[:ai]
			puts "Loading game..."
		else
			puts "Sorry, that file does not contain a saved game. Starting new game..."
		end
		sleep(3)
	end

	def game_over
		swap
		puts "Checkmate! #{current.color} wins! Play again?"
		gets.chomp.downcase[0] == "y" ? restart : exit
	end

	def convert(spot)
		spot = spot.split("")
		char = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6,	"h" => 7, 
						 "8" => 0, "7" => 1, "6" => 2, "5" => 3, "4" => 4, "3" => 5, "2" => 6,	"1" => 7 }
		[char[spot[1]], char[spot[0]]]
	end

	def ai_convert(spot)
		char0 = { 0 => "a", 1 => "b", 2 => "c", 3 => "d", 4 => "e", 5 => "f", 6 => "g", 7 => "h" }
		char1 = { 0 => 8, 1 => 7, 2 => 6, 3 => 5, 4 => 4, 5 => 3, 6 => 2, 7 => 1 }
		"#{char0[spot[1]]}#{char1[spot[0]]}"
	end

	def swap
		@current = @current.color == "White" ? @black : @white
	end

	def promotion?(from, to)
		pawn = board.grid[from[0]][from[1]]
		return false unless pawn.class == Pawn
		return true if pawn.color == "White" && to[0] == 0
		return true if pawn.color == "Black" && to[0] == 7
	end

	def check?(from, to)
		copy = Marshal.load(Marshal.dump(@board))
		copy.update_piece(from, to)
		copy.under_attack?(copy.locate_king(current.color))
	end

	def checkmate?
		pieces = board.grid.flatten.select do |square|
			square.class != String && square.color == current.color
		end.each do |piece|
			moves = piece.possible_moves(@board)
			moves.each do |move|
				return false unless check?([piece.rank, piece.file], move)
			end
		end
		true
	end

	def restart
		game = Game.new
		game.setup
	end
end

game = Game.new
game.setup