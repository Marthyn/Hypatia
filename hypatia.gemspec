Gem::Specification.new do |spec|
  spec.name          = "hypatia"
  spec.version       = "0.0.1"
  spec.authors       = ["Marthyn Olthof"]
  spec.email         = ["Marthyn@live.nl"]
  spec.description   = %q{A gem for determining the difficulty of a basic mathematical operation}
  spec.summary       = %q{A gem for determining the difficulty of a basic mathematical operation}
  spec.homepage      = "http://github.com/marthyn/hypatia"
  spec.license       = "MIT"

  spec.files         = ["lib/hypatia/difficulty-calculator.rb", "lib/hypatia/formula.rb"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "rspec", "~> 0"
end
