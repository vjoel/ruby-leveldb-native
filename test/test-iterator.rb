require 'leveldb-native'
require 'tmpdir'
require 'minitest/autorun'

class TestIterator < Minitest::Test
  include LevelDBNative

  attr_reader :db

  KEYS = (0..9).map {|ki| ki.to_s}

  def setup
    @dir = Dir.mktmpdir "leveldb-test-iterator-"
    @db = DB.new @dir

    KEYS.each_with_index do |k, vi|
      db[k] = vi.to_s
    end
  end

  def teardown
    FileUtils.remove_entry @dir
  end

  def test_each
    db.each_with_index do |(k, v), i|
      assert_equal i.to_s, k
      assert_equal i.to_s, v
    end
  end

  def test_from
    k = 5
    a = db.each(:from => k.to_s).keys
    assert_equal KEYS[k..-1], a
  end

  def test_to
    k = 5
    a = db.each(:to => k.to_s).keys
    assert_equal KEYS[0..k], a
  end

  def test_from_to
    k0 = 5; k1 = 8
    a = db.each(:from => k0.to_s, :to => k1.to_s).keys
    assert_equal KEYS[k0..k1], a
  end

  def test_reverse_each
    assert_equal KEYS.reverse, db.each(:reversed => true).keys
  end

  def test_reverse_from
    k = 5
    a = db.each(:reversed => true, :from => k.to_s).keys
    assert_equal KEYS[0..k].reverse, a
  end

  def test_reverse_to
    k = 5
    a = db.each(:reversed => true, :to => k.to_s).keys
    assert_equal KEYS[k..-1].reverse, a
  end

  def test_reverse_from_to
    k0 = 5; k1 = 8
    a = db.each(:reversed => true, :from => k1.to_s, :to => k0.to_s).keys
    assert_equal KEYS[k0..k1].reverse, a
  end

  def test_iterator_peek
    iter = db.iterator
    assert_equal %w(0 0), iter.peek, iter.invalid_reason
    assert_equal %w(0 0), iter.peek, iter.invalid_reason
    assert_nil iter.scan
    assert_equal %w(1 1), iter.peek, iter.invalid_reason
  end

  def test_iterator_init_with_default_options
    iter = db.iterator
    assert_equal db, iter.db
    assert_nil iter.from
    assert_nil iter.to
    refute iter.reversed?
  end

  def test_iterator_init_with_options
    iter = db.iterator :from => 'abc', :to => 'def', :reversed => true
    assert_equal db,iter.db
    assert_equal 'abc', iter.from
    assert_equal 'def', iter.to
    assert iter.reversed?
  end
  
  def test_iterator_not_valid
    iter = db.iterator from: KEYS[-1]
    assert_nil iter.invalid_reason
    assert_equal %w{9 9}, iter.next
    assert_equal -1, iter.invalid_reason
    assert_equal nil, iter.next
    assert_equal -1, iter.invalid_reason
  end
end
