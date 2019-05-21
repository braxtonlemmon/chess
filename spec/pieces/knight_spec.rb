require "./lib/pieces/knight.rb"

describe Knight do
	let(:knight) { Knight.new(0, 6) }

	describe "#initialize" do
		it "has rank and file" do
			location = [knight.rank, knight.file]
			expect(location).to eq([0, 6])
		end

		it "has a color" do
			expect(knight.color).to eq("Black")
		end

		it "has the correct symbol" do
			expect(knight.symbol).to eq("♞")
		end
	end

	describe "#search" do
		context "when knight has not yet moved" do
			it "returns an array of all possible moves" do
				expect(knight.search).to eq([[1,4], [2,5], [2,7]])
			end
		end
	end

end
