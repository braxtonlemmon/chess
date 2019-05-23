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


end