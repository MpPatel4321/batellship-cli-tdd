# frozen_string_literal: true

require_relative "lib/batellship/version"

Gem::Specification.new do |spec|
  spec.name          = "batellship"
  spec.version       = Batellship::VERSION
  spec.authors       = ["ror.shaan"]
  spec.email         = ["ror.shaan@gmail.com"]
  spec.summary       = "This gem is simulation game of batellship"
  spec.description   = "It run the game according to input text file and generate a new output text file with final output"

  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end

  spec.bindir          = "exe"
  spec.require_paths   = ["lib"]
  spec.files           = Dir["lib/**/*.rb"]

  spec.add_dependency "geocoder"
end
