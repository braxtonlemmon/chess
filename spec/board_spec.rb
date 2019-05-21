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

	describe "#set_board" do
		xit "fills rows 0, 1, 6, and 7" do
			filled = [0, 1, 6, 7]
			block = 
				filled.any? do |row|
					(0..7).any? do |column|
						board.grid[row][column] == " "
					end
				end
			expect(block).to eq(false)
		end
	end
end
