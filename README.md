ruby-leveldb-native
===================

A ruby binding to levelDB. It is native in two senses:

1. Uses libleveldb as a C/C++ ruby extension, rather than through FFI.

2. Uses the natively installed libleveldb, rather than trying to build and install libleveldb as part of the gem.

LevelDB
-------

[LevelDB] (http://code.google.com/p/leveldb/) is a persistent key-value store developed at Google.

Installation
------------

The gem installs in the normal way:

    gem install leveldb-native

However, you need to have libleveldb installed. It may be available as part of your OS (from debian repos, for example), or you may prefer to install from source. The source packages from google do not have install scripts, but that is easy to fix. Here is a git repo with the necessary fixes to the makefile:

    https://github.com/vjoel/leveldb

Just follow the instructions in that repo's README to build and install.

FAQ
---

1.  Why not use the [leveldb gem] (https://github.com/DAddYE/leveldb) instead?

    1.  Doesn't support the full functionality of snapshots. Snapshots in this gem can only be used to switch the state of the DB object, but not act as independent and concurrent readable views of the database at different points in time.

    2.  Tries to maintain its own installation of libleveldb, which may be a different version from the system-wide installation.

    3.  Accesses the lib using FFI, which is slower than ruby's native extension architecture. (See benchmarks at the link above.)

2.  Why not use the [leveldb-ruby gem] (https://github.com/wmorgan/leveldb-ruby) instead?

    1.  Not maintained regularly.

    2.  Tries to maintain its own installation of libleveldb.

    3.  No snapshots.

This gem attempts to maintain compatibility with the leveldb-ruby gem, while adding more features.

Acknowledgement
---------------

This gem owes much to William Morgan's gem, https://github.com/wmorgan/leveldb-ruby.

Contact
-------

This project is hosted at https://github.com/vjoel/leveldb-native.

Joel VanderWerf, vjoel@users.sourceforge.net.

License and Copyright
---------------------

Copyright (c) 2013, Joel VanderWerf.

Portions of ext/leveldb-native/leveldb-native.cc are copyright William Morgan.

License for this project is MIT. See the LICENSE file for the standard MIT license.
