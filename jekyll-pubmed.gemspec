# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-pubmed/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-pubmed"
  spec.version       = Jekyll_Pubmed::VERSION
  spec.authors       = ["Gokul Wimalanathan"]
  spec.email         = ["kokulapalan@gmail.com"]
  spec.summary       = %q{A jekyll plugin to get publication details from pubmed using eutils}
  spec.description   = %q{A jekyll plugin to get publication details from pubmed using eutils}
  spec.homepage      = "https://github.com/wkpalan/jekyll-pubmed.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", "~> 3"

  spec.add_development_dependency "bundler", "~> 1"
  spec.add_development_dependency "rake", "~> 10"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency 'hash-joiner', "~> 0.0"
  spec.add_development_dependency 'crack', "~> 0.4"
end
