require 'rake'
require 'rake/testtask'

PRJ = "leveldb-native"

ext_dir = "ext/#{PRJ}"
so_name = "leveldb_native.so"

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

desc "Build extension"
task :ext => File.join(ext_dir, so_name)

file File.join(ext_dir, so_name) => FileList[
       File.join(ext_dir, "*.{c,cc,h}"),
       File.join(ext_dir, "Makefile")] do
  sh "cd #{ext_dir} && make"
end

file File.join(ext_dir, "Makefile") => File.join(ext_dir, "extconf.rb") do
  sh "cd #{ext_dir} && ruby extconf.rb"
end

desc "Clean compiled files"
task :clean do
  sh "cd #{ext_dir} && make clean"
end

desc "Clean compiled files and Makefile"
task :dist_clean => :clean do
  sh "cd #{ext_dir} && rm Makefile"
end


desc "Run unit tests"
Rake::TestTask.new :test => :ext do |t|
  t.libs << "lib"
  t.libs << "ext"
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
