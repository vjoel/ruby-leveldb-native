require 'leveldb-native'
require 'tmpdir'
require 'minitest/autorun'

class TestDB < Minitest::Test
  include LevelDBNative
  
  attr_reader :db

  def setup
    @dir = Dir.mktmpdir "leveldb-test-db-"
    @db = DB.new @dir
  end

  def teardown
    FileUtils.remove_entry @dir
  end

  def test_size
    1000.times { |x| db.put x.to_s, "foo" }
    assert_equal 1000, db.size
    1000.times { |x| db.delete x.to_s}
    assert_equal 0, db.size
  end
  
  def test_operations
    refute db.exists?("k")

    db["k"] = "v"
    assert_equal "v", db["k"]
    assert db.exists?("k")

    db.delete "k"
    assert_equal nil, db["k"]
    refute db.exists?("k")
  end
  
  ## how to test that fill_cache, verify_checksums, sync are getting passed to
  ## the C++ lib?

  def test_batch
    db['k0'] = '0'
    db['k1'] = '0'

    db.batch do |batch|
      batch['k0'] = '1'
      batch.delete 'k1'
    end

    assert_equal '1', db['k0']
    refute db.exists? 'k1'
  end
end
