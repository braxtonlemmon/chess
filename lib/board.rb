class Board
	attr_accessor :grid

	def initialize
		@grid = Array.new(8) { Array.new(8) { " " } }
	end

	def occupied?(location)
		return grid[location[0]][location[1]] == " " ? false : true
	end



end
