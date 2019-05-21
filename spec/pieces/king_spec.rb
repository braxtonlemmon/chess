require "./lib/pieces/king.rb" 

describe King do
	let(:king) { King.new(7, 4) }

	describe "#initialize" do
		it "has rank and file" do
			location = [king.rank, king.file]
			expect(location).to eq([7, 4])
		end

		it "has a color" do
			expect(king.color).to eq("White")
		end

		it "has the correct symbol" do
			expect(king.symbol).to eq("♔")
		end
	end

	describe "#search" do
		context "when king has not yet moved" do
			it "returns an array of all possible moves (including castling)" do
				expect(king.search.size).to eq(7)
			end
		end

		context "when king has already moved" do
			it "returns an array of all possible moves"do
				king.traveled = true
				expect(king.search.size).to eq(5)
			end
		end
	end

end