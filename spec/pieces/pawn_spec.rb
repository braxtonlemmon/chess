require "./lib/pieces/pawn.rb"

describe Pawn do
	let(:pawn) { Pawn.new(6, 0) }

	describe "#initialize" do
		it "has rank and file" do
			location = [pawn.rank, pawn.file]
			expect(location).to eq([6, 0])
		end

		it "has a color" do
			expect(pawn.color).to eq("White")
		end

		it "has the correct symbol" do
			expect(pawn.symbol).to eq("♟")
		end
	end

	describe "#search" do
		context "when pawn has not yet moved" do
			it "returns an array of both possible moves" do
				expect(pawn.search).to eq([[5,0], [4,0]])
			end
		end
	end
		
end

			