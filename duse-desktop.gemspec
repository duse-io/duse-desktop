# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "duse/desktop/version"

Gem::Specification.new do |s|
  s.name        = "duse-desktop"
  s.version     = Duse::Desktop::VERSION
  s.description = "Desktop client for duse"
  s.homepage    = "https://github.com/duse-io/duse-desktop"
  s.summary     = "Duse Desktop Client"
  s.license     = "MIT"
  s.executables = ["duse-desktop"]
  s.authors     = "Frederic Branczyk"
  s.email       = "fbranczyk@gmail.com"
  s.files       = `git ls-files -z`.split("\x0")
end

