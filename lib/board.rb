require "./lib/pieces/rook.rb"
require "./lib/pieces/knight.rb"
require "./lib/pieces/bishop.rb"
require "./lib/pieces/queen.rb"
require "./lib/pieces/king.rb"
require "./lib/pieces/pawn.rb"


class Board
	attr_accessor :grid, :from, :to

	def initialize
		@grid = Array.new(8) { Array.new(8) { " " } }
		@from = Array.new(2)
		@to = Array.new(2)
	end

	def occupied?(location)
		return grid[location[0]][location[1]] == " " ? false : true
	end

	def set
		rooks   = [[0, 0], [0, 7], [7, 0], [7, 7]]
		knights = [[0, 1], [0, 6], [7, 1], [7, 6]]
		bishops = [[0, 2], [0, 5], [7, 2], [7, 5]]
		queens  = [[0, 3], [7, 3]]
		kings   = [[0, 4], [7, 4]]
		pawns   = [[1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [1,6], [1,7],
							 [6,0], [6,1], [6,2], [6,3], [6,4], [6,5], [6,6], [6,7]]
		rooks.each { |n| @grid[n[0]][n[1]] = Rook.new(n[0], n[1]) }
		knights.each { |n| @grid[n[0]][n[1]] = Knight.new(n[0], n[1]) }
		bishops.each { |n| @grid[n[0]][n[1]] = Bishop.new(n[0], n[1]) }
		queens.each { |n| @grid[n[0]][n[1]] = Queen.new(n[0], n[1]) }
		kings.each { |n| @grid[n[0]][n[1]] = King.new(n[0], n[1]) }
		pawns.each { |n| @grid[n[0]][n[1]] = Pawn.new(n[0], n[1]) }
	end

	def show
		puts
		x = 8
		n = 0
		(0..7).each do |rank|
			line = []
			(0..7).each { |file| line << (spot_empty?(rank,file) ? "•" : grid[rank][file].symbol) }
			puts " " + line.join("  ") + " #{x}" + " [#{n}]"
			n += 1
			x -= 1
		end
		("a".."h").each { |char| print " #{char} " }
		puts
		(0..7).each { |num| print "[#{num}]" }
		puts puts
	end

	def spot_empty?(rank, file)
		(grid[rank][file] == " ") ? true : false
	end

	def spot_available?(from, to)
		return true if spot_empty?(to[0], to[1])
		color1 = grid[from[0]][from[1]].color
		color2 = grid[to[0]][to[1]].color
		return true if color1 != color2
		false
	end

	def move(from, to)
		from = convert(from)
		to = convert(to)
		grid[to[0]][to[1]] = grid[from[0]][from[1]]
		grid[from[0]][from[1]] = " "

	end

	def convert(spot)
		char = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6,	"h" => 7, 
						 "8" => 0, "7" => 1, "6" => 2, "5" => 3, "4" => 4, "3" => 5, "2" => 6,	"1" => 7 }
		spot = spot.split("")
		[char[spot[1]], char[spot[0]]]
	end

	def allowed?(from, to)
		from = convert(from)
		to = convert(to)
		piece_moves = grid[from[0]][from[1]].search
		return true if piece_moves.include?(to) && path_clear?(from, to) && spot_available?(from, to)
		false
	end

	def horizontal_clear?(from, to)
		files = from[1] < to[1] ? ((from[1] + 1)...to[1]) : ((to[1] + 1)...from[1])
		return true if files.all? { |file| spot_empty?(from[0], file) }
		false
	end

	def vertical_clear?(from, to)
		ranks = from[0] < to[0] ? ((from[0] + 1)...to[0]) : ((to[0] + 1)...from[0])
		return true if ranks.all? { |rank| spot_empty?(rank, from[1]) }
		false
	end

	def diagonal_clear?(from, to)
		file = from[1]
		case true
		when to[0] < from[0] && to[1] > from[1]
			return true if (from[0]-1).downto(to[0]+1).all? do |rank|
												file += 1
												spot_empty?(rank, file)
			end
		when to[0] > from[0] && to[1] > from[1]
			return true if (from[0]+1...to[0]).all? do |rank|
												file += 1
												spot_empty?(rank, file)
			end
		when to[0] > from[0] && to[1] < from[1]
			return true if (from[0]+1...to[0]).all? do |rank|
												file -= 1
												spot_empty?(rank, file)
			end
		when to[0] < from[0] && to[1] < from[1]
			return true if (from[0]-1).downto(to[0]+1).all? do |rank|
												file -= 1
												spot_empty?(rank, file)
			end
		end
		false
	end

	def path_clear?(from, to)
		if from[0] == to[0]
			return true if horizontal_clear?(from, to)
		elsif from[1] == to[1]
			return true if vertical_clear?(from, to)
		elsif ((from[0] - to[0])**2) == ((from[1] - to[1])**2)
			return true if diagonal_clear?(from, to)
		end
		false
	end

end
