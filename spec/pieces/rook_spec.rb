require "./lib/pieces/rook.rb"

describe Rook do
	let(:rook) { Rook.new(0, 0) }

	describe "#initialize" do
		it "has rank and file" do
			location = [rook.rank, rook.file]
			expect(location).to eq([0, 0])
		end

		it "has a color" do
			expect(rook.color).to eq("Black")
		end

		it "has the correct symbol" do
			expect(rook.symbol).to eq("♖")
		end
	end

	describe "#search" do
		context "when rook has not yet moved" do
			it "returns an array of all possible moves" do
				expect(rook.search.size).to eq(14)
			end
		end
	end

end
