require "./lib/board.rb"

describe Board do
	let(:board) { Board.new }

	describe "#initialize" do
		it "creates an 8x8 grid" do
			expect(board.grid).to eq(Array.new(8) { Array.new(8) { " " } })
		end
	end

	describe "#occupied?" do
		context "when spot is not occupied" do
			it "returns false" do
				expect(board.occupied?([0, 1])).to eq(false)
			end
		end

		context "when spot is occupied" do
			it "returns true" do
				board.grid[0][0] = "x"
				expect(board.occupied?([0, 0])).to eq(true)
			end
		end
	end

	describe "#set" do
		it "fills rows 0, 1, 6, and 7" do
			filled = [0, 1, 6, 7]
			block = 
				filled.any? do |row|
					(0..7).any? do |column|
						spot = board.grid[row][column]
						puts spot
					end
				end
			expect(block).to eq(false)
		end
	end

	describe "#convert" do
		it "converts user input to correct array coordinates" do
			expect(board.convert("b3")).to eq([5, 1])
		end
	end

	describe "#move" do
		it "moves a pawn forward one" do
			board.set
			board.move("d2","d3")
			expect(board.spot_empty?(5, 3)).to eq(false)
			expect(board.spot_empty?(6, 3)).to eq(true)
		end
	end

	describe "#allowed?" do
		before(:each) { board.set }
		context "when a move is allowed" do
			it "returns true" do
				board.show
				expect(board.allowed?("e2", "e3")).to eq(true)
			end
		end
		
		context "when another piece is blocking a move" do
			it "returns false" do
				expect(board.allowed?("f1", "g2")).to eq(false)
			end
		end

		context "when the moving piece cannot move like that" do
			it "returns false" do
				expect(board.allowed?("h7", "h4")).to eq(false)
			end
		end
	end

	describe "horizontal_clear?" do
		before(:each) do
			board.set
			board.move("e2", "e4")
			board.move("d1", "f3")
		end
		context "when path is clear" do
			it "returns true along right horizontal" do
				expect(board.horizontal_clear?([5,5],[5,7])).to eq(true)
			end

			it "returns true along left horizontal" do
				expect(board.horizontal_clear?([5,5],[5,3])).to eq(true)
			end
		end

		context "when path is blocked" do
			it "returns false along east horizontal" do
				expect(board.horizontal_clear?([0,0],[0,2])).to eq(false)
			end

			it "returns false along west horizontal" do
				expect(board.horizontal_clear?([7,7],[7,3])).to eq(false)
			end
		end
	end

	describe "#vertical_clear?" do
		before(:each) do
			board.set
			board.move("e2", "e4")
			board.move("d1", "f3")
		end

		context "when path is clear" do
			it "returns true along north vertical" do
				expect(board.vertical_clear?([1,0],[2,0])).to eq(true)
			end

			it "returns true along south vertical" do
				expect(board.vertical_clear?([1,5],[3,5])).to eq(true)
			end
		end

		context "when path is blocked" do
			it "returns false along north vertical" do
				expect(board.vertical_clear?([7,7],[4,7])).to eq(false)
			end

			it "returns false along south vertical" do
				expect(board.vertical_clear?([0,0],[4,0])).to eq(false)
			end
		end

	end

	describe "#diagonal_clear?" do
		before(:each) do
			board.set
			board.move("e2", "e4")
			board.move("d1", "f3")
		end

		context "when path is clear" do
			it "returns true along NE diagonal" do
				expect(board.diagonal_clear?([5,5],[3,7])).to eq(true)
			end

			it "returns true along SE diagonal" do
				board.move("f3", "f5")
				expect(board.diagonal_clear?([3,5],[5,7])).to eq(true)
			end

			it "returns true along SW diagonal" do
				board.move("f5", "d5")
				expect(board.diagonal_clear?([3,3],[5,1])).to eq(true)
			end

			it "returns true along NW diagonal" do
				board.move("d5", "d3")
				expect(board.diagonal_clear?([5,3],[2,0])).to eq(true)
			end
		end

		context "when path is blocked" do
			it "returns false along NE diagonal" do
				expect(board.diagonal_clear?([5,3],[2,6])).to eq(false)
			end

			it "returns false along SE diagonal" do
				expect(board.diagonal_clear?([0,2],[3,5])).to eq(false)
			end

			it "returns false along SW diagonal" do
				expect(board.diagonal_clear?([0,5],[3,3])).to eq(false)
			end

			it "returns false along NW diagonal" do
				board.move("f3", "d3")
				expect(board.diagonal_clear?([7,5],[4,2])).to eq(false)
			end
		end
	end
		
	describe "#path_clear?" do
		before(:each) do
			board.set
			board.move("e2", "e4")
			board.move("d1", "f3")
		end
		
		context "when path is clear" do
			it "returns true along NE diagonal" do
				expect(board.path_clear?([5,5],[3,7])).to eq(true)
			end

			it "returns true along SE diagonal" do
				board.move("f3", "f5")
				expect(board.path_clear?([3,5],[5,7])).to eq(true)
			end

			it "returns true along SW diagonal" do
				board.move("f5", "d5")
				expect(board.path_clear?([3,3],[5,1])).to eq(true)
			end

			it "returns true along NW diagonal" do
				board.move("d5", "d3")
				expect(board.path_clear?([5,3],[2,0])).to eq(true)
			end

			it "returns true along horizontal" do
				expect(board.path_clear?([5,5],[5,7])).to eq(true)
			end

			it "returns true along vertical" do
				expect(board.path_clear?([1,0],[2,0])).to eq(true)
			end
		end

		context "when path is blocked" do
			it "returns false along NE diagonal" do
				expect(board.path_clear?([5,3],[2,6])).to eq(false)
			end

			it "returns false along SE diagonal" do
				expect(board.path_clear?([0,2],[3,5])).to eq(false)
			end

			it "returns false along SW diagonal" do
				expect(board.path_clear?([0,5],[3,3])).to eq(false)
			end

			it "returns false along NW diagonal" do
				board.move("f3", "d3")
				expect(board.path_clear?([7,5],[4,2])).to eq(false)
			end

			it "returns false along horizontal" do
				expect(board.path_clear?([0,0],[0,2])).to eq(false)
			end

			it "returns false along vertical" do
				expect(board.path_clear?([7,7],[4,7])).to eq(false)
			end
		end
	end

	describe "#spot_available?" do
		before(:each) do
			board.set
			board.move("g2","g3")
			board.move("h2","h3")
		end

		context "when spot is occupied with same color" do
			it "returns false" do
				expect(board.spot_available?([7,5],[5,7])).to eq(false)
			end
		end

		context "when spot is empty" do
			it "returns true" do
				expect(board.spot_available?([7,5],[6,6])).to eq(true)
			end
		end

		context "when spot is occupied with other color" do
			it "returns true" do 
				board.move("f1","g2")
				expect(board.spot_available?([6,6],[1,1])).to eq(true)
			end
		end
	end

			
end

=begin 
* user inputs location of piece to move (from)
* user inputs location to move piece to (to)
* #allowed? checks:
	1. if piece can move like that with #piece.search
			if yes            ==> CONTINUE
			if no             ==> STOP

  2. if path is clear with #path_clear?
			if yes            ==> CONTINUE
			if no             ==> STOP

	3. if spot is empty using #spot_empty?
			if empty          ==> TRUE
			if opposite color ==> TRUE
			if same color     ==> FALSE

	
* if #allowed? returns true, then #move occurs

#path_clear?
	* if from and to are in same rank
	* if from and to are in same file
	* if from and to are in diagonal

=end
