# frozen_string_literal: true

require "optparse"

module Batellship
  # The `Batellship` class represents a battleship game.
  # It handles the setup of the game board, placement of ships,
  # and gameplay mechanics such as firing shots and determining
  # the outcome of each turn.
  class Batellship
    attr_reader :m, :s, :p1_positions, :p2_positions, :t, :p1_moves, :p2_moves

    def run
      parse_options
      input_file = ARGV.first

      if input_file.nil?
        puts "Error: Please provide an input file."
        exit 1
      end

      run_battle_field(input_file)
    end

    def run_battle_field(input_file)
      output_file = "outputs/output_#{Time.now.tv_sec}.txt"
      initialize_variables(input_file)
      validate_inputs
      File.open(output_file, "w") { |file| file.puts(generate_output) }
      puts "You can see your result in `#{output_file}`"
    end

    private

    def parse_options
      OptionParser.new do |opts|
        opts.on("--help", "Print this help message") do
          print_help
          exit 1
        end
      end.parse!
    end

    def initialize_variables(input_file)
      m, s, p1_positions, p2_positions, t, p1_moves, p2_moves = File.read(input_file).split("\n")
      @m = m.to_i
      @s = s.to_i
      @t = t.to_i
      @p1_positions = split_variables(p1_positions)
      @p2_positions = split_variables(p2_positions)
      @p1_moves = split_variables(p1_moves)
      @p2_moves = split_variables(p2_moves)
    end

    def validate_inputs
      variables = instance_variables.map { |var| var.to_s.gsub("@", "").split("_").last }.uniq
      errors = ""
      variables.each do |variable|
        errors += send("validate_#{variable}").to_s
      end
      return if errors.empty?

      puts errors
      exit
    end

    def split_variables(str)
      str.split(":")
    end

    def validate_m
      "\n the size of the battleground should be gratter then 0 and less then 11" if m.zero? || m > 10
    end

    def validate_s
      "\n the number of ships should be gratter then 0 and less then #{((m * m) / 2) - 1}" if s.zero? || s > (m * m) / 2
    end

    def validate_positions
      "\n the number of ships should be #{s}" if p1_positions.size != s || p2_positions.size != s
    end

    def validate_t
      "\n the size of the missiles should be gratter then 0 and less then #{(m * m) + 1}" if t.zero? || t > (m * m)
    end

    def validate_moves
      "\n the number of missiles should be #{t}" if p1_moves.size != t || p2_moves.size != t
    end

    def generate_output
      str = "Player 1\n"
      str += format_battlefield(p1_battellfield)
      str += "\nPlayer 2\n"
      str += format_battlefield(p2_battellfield)
      str += "\nP1:#{p1_score}\nP2:#{p2_score}\n"
      str + determine_winner(p1_score, p2_score)
    end

    def p1_battellfield
      @p1_battellfield ||= dynamic_array(p1_positions, p2_moves)
    end

    def p2_battellfield
      @p2_battellfield ||= dynamic_array(p2_positions, p1_moves)
    end

    def p1_score
      @p1_score ||= p2_battellfield.flatten.count("X")
    end

    def p2_score
      @p2_score ||= p1_battellfield.flatten.count("X")
    end

    def dynamic_array(positions, moves)
      (0..m.to_i).map do |x|
        (0..m.to_i).map do |y|
          insert_array_item("#{x},#{y}", positions, moves)
        end
      end
    end

    def insert_array_item(key, positions, moves)
      if positions.include?(key)
        moves.include?(key) ? "X" : "B"
      elsif moves.include?(key)
        "O"
      else
        "_"
      end
    end

    def format_battlefield(battlefield)
      battlefield.map { |a| a.join(" ") }.join("\n")
    end

    def determine_winner(p1_score, p2_score)
      if p1_score == p2_score
        "It is a draw"
      elsif p1_score > p2_score
        "Player 1 won"
      else
        "Player 2 won"
      end
    end

    def print_help
      puts <<-HELP
        Usage: ./cli [OPTIONS/FILE]

        Options:
          --help                 Print this help message
        File:
          file_dir(input.txt)    Specify output file (default: STDOUT)

        Examples:
          ./cli --help
          ./cli input.txt        # will generate output.txt in your current directory.
      HELP
    end
  end
end
