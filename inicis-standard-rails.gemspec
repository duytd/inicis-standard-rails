# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inicis/standard/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "inicis-standard-rails"
  spec.version       = Inicis::Standard::Rails::VERSION
  spec.authors       = ["Trinh Duc Duy"]
  spec.email         = ["duytd.hanu@gmail.com"]

  spec.summary       = %q{INICIS Standard Payment for Korean Merchant.}
  spec.description   = %q{Processing online payment via INICIS Standard Payment Gateway".}
  spec.homepage      = "https://github.com/duytd/inicis-standard-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency "thrift"
  spec.add_dependency "browser"
  spec.add_dependency "iconv"
end
