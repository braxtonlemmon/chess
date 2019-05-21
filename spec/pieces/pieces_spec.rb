require "./lib/pieces/pieces.rb"
include Pieces

describe Piece do
	let(:piece) { Piece.new(3,4) }
	describe "#ok_move?" do
		context "when the end location is on the board" do
			it "returns true" do
				distance = [1,1]
				expect(piece.ok_move?(distance)).to eq(true)
			end
		end

		context "when the end location is not on the board" do
			it "returns false" do
				distance = [8,0]
				expect(piece.ok_move?(distance)).to eq(false)
			end
		end
	end

	describe "#possible_moves" do
		it "returns an array possible moves" do
			piece.moves = [[-1,0], [-2,0]]
			expect(piece.possible_moves).to eq([[2,4], [1,4]])
		end
	end			

end