require "./lib/game.rb"

describe Game do
	let(:game) { Game.new }

	
	describe "#initialize" do
		it "makes white (first) player the color white" do
			player1 = game.white
			expect(player1.color).to eq("White")
		end

		it "makes black (second) player the color black" do
			player2 = game.black
			expect(player2.color).to eq("Black")
		end

		it "sets @current as @white" do
			expect(game.current).to eq(game.white)
		end
	end

	describe "#convert" do
		it "converts user input to correct array coordinates" do
			expect(game.convert("b3")).to eq([5, 1])
		end
	end

	describe "#ask_user_choice" do
		xit "returns an array of two numbers" do
			game.ask_user_choice #"d2" to "d3"
			expect(result).to eq([[6,3],[5,3]])
		end
	end

	describe "#color_ok?" do
		context "when color of @current matches selected piece" do
			it "returns true" do 
				expect(game.color_ok?([6,0])).to eq(true)
			end
		end
	end

	describe "#locate_king" do
		it "gives coordinates of king of current player" do
			expect(game.locate_king).to eq([7,4])
		end
	end

	describe "#check?" do
		before(:each) do
			game.board.update_piece([6,4],[4,4])
			game.board.update_piece([1,3],[2,3])
			game.board.update_piece([7,5],[3,1])
			game.board.update_piece([1,4],[3,4])
			game.swap
		end
		
		context "when king is in check" do
			it "returns true" do
				expect(game.check?).to eq(true)
				game.board.show
			end
		end

		context "when king is not in check" do
			it "returns false" do
				game.board.update_piece([0,3],[1,3])
				expect(game.check?).to eq(false)
				game.board.show
			end
		end
	end


end
