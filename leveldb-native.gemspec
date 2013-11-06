require 'leveldb-native/version'

Gem::Specification.new do |s|
  s.name = "leveldb-native"
  s.version = LevelDBNative::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0")
  s.authors = ["Joel VanderWerf"]
  s.date = Time.now.strftime "%Y-%m-%d"
  s.description = "Ruby binding to LevelDB."
  s.email = "vjoel@users.sourceforge.net"
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = Dir[
    "README.md", "LICENSE", "Rakefile",
    "lib/**/*.rb",
    "ext/**/*.rb",
    "bin/**/*.rb",
    "bench/**/*.rb",
    "example/**/*.rb",
    "test/**/*.rb"
  ]
  s.bindir = 'bin'
  s.test_files = Dir["test/*.rb"]
  s.homepage = "https://github.com/vjoel/ruby-leveldb-native"
  s.license = "MIT"
  s.rdoc_options = [
    "--quiet", "--line-numbers", "--inline-source",
    "--title", "LevelDB Native", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.summary = "Ruby binding to LevelDB."
end
