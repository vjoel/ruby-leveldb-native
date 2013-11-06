require 'leveldb-native'
require 'tmpdir'
require 'minitest/autorun'

class TestDBOptions < Minitest::Test
  include LevelDBNative
  
  attr_reader :dir

  def setup
    @dir = Dir.mktmpdir "leveldb-test-db-options-"
  end

  def teardown
    FileUtils.remove_entry @dir
  end

  def test_create_if_missing_behavior
    assert_raises(Error) do
      DB.make(dir, {}) # create_if_missing is false
    end
    db = DB.make dir, :create_if_missing => true
    assert db.options.create_if_missing
    db.close!

    db2 = DB.make dir, {}
    refute db2.options.create_if_missing
    db2.close!

    FileUtils.rm_rf dir

    DB.new dir # by default should set create_if_missing to true
  end

  def test_error_if_exists_behavior
    db = DB.make dir, :create_if_missing => true
    refute db.options.error_if_exists
    db.close!

    assert_raises(Error) do
      DB.make dir, :create_if_missing => true, :error_if_exists => true
    end
  end

  def test_paranoid_check_default
    db = DB.new dir
    refute db.options.paranoid_checks
  end

  def test_paranoid_check_on
    db = DB.new dir, :paranoid_checks => true
    assert db.options.paranoid_checks
  end

  def test_paranoid_check_off
    db = DB.new dir, :paranoid_checks => false
    refute db.options.paranoid_checks
  end

  def test_write_buffer_size_default
    db = DB.new dir
    assert_equal Options::DEFAULT_WRITE_BUFFER_SIZE,
      db.options.write_buffer_size
  end

  def test_write_buffer_size
    db = DB.new dir, :write_buffer_size => 10 * 1042
    assert_equal (10 * 1042), db.options.write_buffer_size
  end

  def test_write_buffer_size_invalid
    assert_raises(TypeError) do
      DB.new dir, :write_buffer_size => "1234"
    end
  end

  def test_max_open_files_default
    db = DB.new dir
    assert_equal Options::DEFAULT_MAX_OPEN_FILES, db.options.max_open_files
  end

  def test_max_open_files
    db = DB.new(dir, :max_open_files => 2000)
    assert_equal db.options.max_open_files, 2000
  end

  def test_max_open_files_invalid
    assert_raises(TypeError) do
      DB.new dir, :max_open_files => "2000"
    end
  end

  def test_cache_size_default
    db = DB.new dir
    assert_nil db.options.block_cache_size
  end

  def test_cache_size
    db = DB.new dir, :block_cache_size => 10 * 1024 * 1024
    assert_equal (10 * 1024 * 1024), db.options.block_cache_size
  end

  def test_cache_size_invalid
    assert_raises(TypeError) do
      DB.new dir, :block_cache_size => false
    end
  end

  def test_block_size_default
    db = DB.new dir
    assert_equal Options::DEFAULT_BLOCK_SIZE, db.options.block_size
  end

  def test_block_size
    db = DB.new dir, :block_size => (2 * 1024)
    assert_equal (2 * 1024), db.options.block_size
  end

  def test_block_size_invalid
    assert_raises(TypeError) do
      DB.new dir, :block_size => true
    end
  end

  def test_block_restart_interval_default
    db = DB.new dir
    assert_equal Options::DEFAULT_BLOCK_RESTART_INTERVAL,
      db.options.block_restart_interval
  end

  def test_block_restart_interval
    db = DB.new dir, :block_restart_interval => 32
    assert_equal 32, db.options.block_restart_interval
  end

  def test_block_restart_interval_invalid
    assert_raises(TypeError) do
      DB.new dir, :block_restart_interval => "abc"
    end
  end

  def test_compression_default
    db = DB.new dir
    assert_equal Options::DEFAULT_COMPRESSION, db.options.compression
  end

  def test_compression
    db = DB.new dir, :compression => CompressionType::NoCompression
    assert_equal CompressionType::NoCompression, db.options.compression
  end

  def test_compression_invalid_type
    assert_raises(TypeError) { DB.new dir, :compression => "1234" }
    assert_raises(TypeError) { DB.new dir, :compression => 999 }
  end
end
