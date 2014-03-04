where_lower
===========

Provide an easy way to use case insensitive `where` in ActiveRecord.

### Support
===========
Tested against:
- Active Record of version `3.1`, `3.2` and `4.0`
- Ruby `1.9.2`, `1.9.3`, `2.0.0` (except Rails 4 with `1.9.2`)

[![Build Status](http://img.shields.io/travis/PikachuEXE/where_lower.svg)](https://travis-ci.org/PikachuEXE/where_lower)
[![Gem Version](http://img.shields.io/gem/v/where_lower.svg)](http://badge.fury.io/rb/where_lower)
[![Dependency Status](http://img.shields.io/gemnasium/PikachuEXE/where_lower.svg)](https://gemnasium.com/PikachuEXE/where_lower)
[![Coverage Status](http://img.shields.io/coveralls/PikachuEXE/where_lower.svg)](https://coveralls.io/r/PikachuEXE/where_lower)
[![Code Climate](http://img.shields.io/codeclimate/github/PikachuEXE/where_lower.svg)](https://codeclimate.com/github/PikachuEXE/where_lower)

Install
=======

```ruby
gem 'where_lower'
```

Usage
=====
Supports `String`, `Array`, `Range`  
Values in `Array` and `Range` will be converted to `String` and then `downcase`  
Other types will not be touched

```ruby
SomeActiveRecordClass.where_lower(attribute1: 'AbC', attribute2: ['stRing', 123, :symBol], attribute3: ('AA'..'AZ'))
```

Since `0.3.0`  
You can pass a nested hash (1 level deep only) for association condition
```ruby
record.association_records.where_lower(association_table: {association_column: value})
```

You can also add table name in key if you are using it with association  
I don't plan to support any "smart" table guessing though
```ruby
record.association_records.where_lower('association_table.association_column' => value)
```

Contributors
============
[Matthew Rudy Jacobs](https://github.com/matthewrudy) (Who wrote the first version of `where_lower` method)
