require "./lib/pieces/bishop.rb"

describe Bishop do
	let(:bishop) { Bishop.new(7, 2) }

	describe "#initialize" do
		it "has rank and file" do
		
			location = [bishop.rank, bishop.file]
			expect(location).to eq([7, 2])
		end
		it "has a color" do
			expect(bishop.color).to eq("White")
		end

		it "has the correct symbol" do
			expect(bishop.symbol).to eq("♝")
		end
	end

	describe "#search" do
		context "when bishop has not yet moved" do
			it "returns an array of all possible moves" do
				expect(bishop.search.size).to eq(7)
			end
		end

		context "when bishop is in middle of board" do
			it "returns an array of all possible moves" do
				bishop.rank, bishop.file = [3, 3]
				expect(bishop.search.size).to eq(13)
			end
		end
	end
end