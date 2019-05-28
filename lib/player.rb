class Player
	attr_reader :color
	# @@count = 0
	
	# def initialize
	# 	@@count += 1
	# 	@color = (@@count == 1 ? "White" : "Black")
	# end

	def initialize(color)
		@color = color
	end
end
