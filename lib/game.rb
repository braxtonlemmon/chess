


	def ask_user_choice
		puts "Enter coordinates of piece you wish to move: "
		from = gets.chomp
		puts "Enter coordinates of where you wish to move #{from}: "
		to = gets.chomp
		[from, to]
	end