require 'leveldb-native'
require 'tmpdir'
require 'minitest/autorun'

class TestSnapshot < Minitest::Test
  include LevelDBNative
  
  attr_reader :db

  KEYS = %w{ k1 k2 k3 }

  def setup
    @dir = Dir.mktmpdir "leveldb-test-snapshot-"
    @db = DB.new @dir

    KEYS.each do |k|
      db[k] = "0"
    end
  end

  def teardown
    FileUtils.remove_entry @dir
  end

  def test_get
    sn = db.snapshot
    KEYS.each do |k|
      db[k] = "1"
    end
    KEYS.each do |k|
      assert_equal "0", sn[k]
    end
  end

  def test_iterator
    sn = db.snapshot
    KEYS.each do |k|
      db[k] = "1"
    end
    sn.each do |k,v|
      assert_equal "0", v
    end
    assert_equal KEYS, sn.keys
    assert_equal ["0"], sn.values.uniq
  end

  def test_exists
    sn = db.snapshot
    db["new"] = "new"
    db.delete "k1"
    assert_equal false, sn.exists?( "new" )
    assert_equal true,  sn.exists?( "k1"  )
    assert_equal true,  db.exists?( "new" )
    assert_equal false, db.exists?( "k1"  )

    sn.release
    assert_equal true,  sn.exists?( "new" )
    assert_equal false, sn.exists?( "k1"  )
    assert_equal true,  db.exists?( "new" )
    assert_equal false, db.exists?( "k1"  )
  end

  def test_release
    sn = db.snapshot
    KEYS.each do |k|
      db[k] = "1"
    end

    assert_equal false, sn.released?
    sn.release
    assert_equal true, sn.released?

    sn.each do |k,v|
      assert_equal "1", v
    end
  end
end
