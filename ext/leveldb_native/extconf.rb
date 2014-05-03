require 'mkmf'

dir_config('leveldb')

have_library "leveldb" or abort "Can't find leveldb library."

create_makefile "leveldb-native/leveldb_native"
