require "./lib/player.rb"

describe Player do
	it "resets class variable @@count to 0" do
		Player.class_variable_set(:@@count, 0)
		expect(Player.class_variable_get(:@@count)).to eq(0)
	end

	describe "#initialize" do
		context "when creating first player" do
			it "sets player color to White" do
				player_one = Player.new
				expect(player_one.color).to eq("White")
			end
		end

		context "when creating second player" do
			it "sets player color to Black" do
				player_two = Player.new
				expect(player_two.color).to eq("Black")
			end
		end
	end
end