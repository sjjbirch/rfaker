# frozen_string_literal: true

require_relative "lib/rfaker/version"

Gem::Specification.new do |spec|
  spec.name = "rfaker"
  spec.version = Rfaker::VERSION
  spec.authors = ["Solomon Birch"]
  spec.email = ["birch.jj@gmail.com"]

  spec.summary = "Randomised generators for faker."
  spec.description = "A gem to allow the randomised or conditional selection of generators for the Ruby Faker gem for eg `rfaker.rd([dog,cat],[1,2])` will return any dog based generator 1/3 of the time and any cat based generator 2/3 of the time."
  spec.homepage = "https://github.com/sjjbirch/rfaker"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://github.com/sjjbirch/rfaker"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sjjbirch/rfaker"
  spec.metadata["changelog_uri"] = "https://github.com/sjjbirch/rfaker"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
