require 'rake'
require 'rake/testtask'
require 'rake/extensiontask'

PRJ = "leveldb-native"

def version
  @version ||= begin
    require 'leveldb-native/version'
    warn "LevelDBNative::VERSION not a string" unless
      LevelDBNative::VERSION.kind_of? String
    LevelDBNative::VERSION
  end
end

def tag
  @tag ||= "#{PRJ}-#{version}"
end

Rake::ExtensionTask.new "leveldb_native" do |ext|
  ext.lib_dir = "lib/leveldb-native"
end

desc "Run unit tests"
Rake::TestTask.new :test => :compile do |t|
  t.libs << "lib"
  t.test_files = FileList["test/*.rb"]
end

desc "Test, commit, tag, and push repo; build and push gem"
task :release => ["release:is_new_version", :test] do
  require 'tempfile'
  
  sh "gem build #{PRJ}.gemspec"

  file = Tempfile.new "template"
  begin
    file.puts "release #{version}"
    file.close
    sh "git commit --allow-empty -a -v -t #{file.path}"
  ensure
    file.close unless file.closed?
    file.unlink
  end

  sh "git tag #{tag}"
  sh "git push"
  sh "git push --tags"
  
  sh "gem push #{tag}.gem"
end

namespace :release do
  desc "Diff to latest release"
  task :diff do
    latest = `git describe --abbrev=0 --tags --match '#{PRJ}-*'`.chomp
    sh "git diff #{latest}"
  end

  desc "Log to latest release"
  task :log do
    latest = `git describe --abbrev=0 --tags --match '#{PRJ}-*'`.chomp
    sh "git log #{latest}.."
  end

  task :is_new_version do
    abort "#{tag} exists; update version!" unless `git tag -l #{tag}`.empty?
  end
end
