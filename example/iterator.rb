require 'leveldb-native'

db = LevelDBNative::DB.new '/tmp/leveldb-example-iterator'

(1..10).each do |i|
  db[i.to_s] = (i*100).to_s
end

p db.to_a # db is enumerable, so #to_a, #map, etc. work
# note, not numerical order, but lexicographic order.

db.reverse_each :from => "3", :to => "6" do |k,v|
  puts "#{k} : #{v}"
end

iter = db.iterator # same as calling #each without block

p iter.peek
iter.scan
p iter.peek

iter = db.iterator :from => "5"
iter.scan
p iter.peek
