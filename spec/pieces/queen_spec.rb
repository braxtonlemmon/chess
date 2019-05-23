require "./lib/pieces/queen.rb"

describe Queen do
	let(:queen) { Queen.new(7, 3) }

	describe "#initialize" do
		it "has rank and file" do
			location = [queen.rank, queen.file]
			expect(location).to eq([7, 3])
		end
		
		it "has a color" do
			expect(queen.color).to eq("White")
		end

		it "has the correct symbol" do
			expect(queen.symbol).to eq("♛")
		end
	end

	describe "#search" do
		context "when queen has not yet moved" do
			it "returns an array of all possible moves" do
				expect(queen.search.size).to eq(21)
			end
		end
	end
end