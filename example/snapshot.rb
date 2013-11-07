require 'leveldb-native'

db = LevelDBNative::DB.new '/tmp/leveldb-example-snapshot'

db["a"] = "1"
db["b"] = "1"
db.delete "c"
puts "initialized database to #{db.to_a}"
puts

puts "snapshot:"
db.snapshot do |sn|
  puts "value at a is #{sn["a"]}"
  sn.each {|k,v| puts "  #{k} => #{v}"}
end
puts

sn = db.snapshot
puts "taking new snapshot"
db["b"] = "2"
puts "put 'b' => #{db["b"].inspect}"
db["c"] = "2"
puts "put 'c' => #{db["c"].inspect}"

puts "snapshot is: #{sn.to_a}"
puts "database is: #{db.to_a}"
puts

sn.release
puts "relasing snapshot (will now reflect current db state)"
puts "snapshot is: #{sn.to_a}"
puts "database is: #{db.to_a}"
puts
