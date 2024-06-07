# frozen_string_literal: true

require_relative "../batellship/batellship" # Assuming your script is named cli.rb
RSpec.describe "Batellship" do
  let(:batellship) { Batellship::Batellship.new }

  describe "#run" do
    context "when --help option is provided" do
      it "prints help message and exits" do
        ARGV.replace(["--help"])
        expect { batellship.run }.to output(/Usage:/).to_stdout.and raise_error(SystemExit)
      end
    end

    context "when input txt is not provided" do
      it "prints an error message and exits with status 1" do
        ARGV.clear
        expect { batellship.run }.to output(/Error: Please provide an input file/).to_stdout.and raise_error(SystemExit)
      end
    end
  end

  describe "#run_battle_field" do
    before do
      allow_any_instance_of(Time).to receive(:tv_sec).and_return(123)
    end

    after do
      File.delete(output_file) if File.exist?(output_file)
    end

    context "when a input txt file is provided" do
      let(:valid_txt) { "lib/fixtures/draw.txt" }
      let(:player_one_win) { "lib/fixtures/player_one_win.txt" }
      let(:player_two_win) { "lib/fixtures/player_two_win.txt" }
      let(:invalid_input) { "lib/fixtures/invalid_input.txt" }
      let(:output_file) { "outputs/output_123.txt" }
      let(:output_data) { File.read(output_file) }

      it "when valid input file with draw data" do
        batellship.run_battle_field(valid_txt)
        expect(output_data).to include("It is a draw")
      end

      it "when valid input file with player one win data" do
        batellship.run_battle_field(player_one_win)
        expect(output_data).to include("Player 1 won")
      end

      it "when valid input file with player two win data" do
        batellship.run_battle_field(player_two_win)
        expect(output_data).to include("Player 2 won")
      end

      it "with invalid data file" do
        expect do
          batellship.run_battle_field(invalid_input)
        end.to output(/the size of the battleground should be gratter then 0 and less then 11/).to_stdout
      end
    end
  end
end
