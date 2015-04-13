# where_lower

Provide an easy way to use case insensitive `where` in ActiveRecord.


## Status

[![Build Status](http://img.shields.io/travis/PikachuEXE/where_lower.svg?style=flat-square)](https://travis-ci.org/PikachuEXE/where_lower)
[![Gem Version](http://img.shields.io/gem/v/where_lower.svg?style=flat-square)](http://badge.fury.io/rb/where_lower)
[![Dependency Status](http://img.shields.io/gemnasium/PikachuEXE/where_lower.svg?style=flat-square)](https://gemnasium.com/PikachuEXE/where_lower)
[![Coverage Status](http://img.shields.io/coveralls/PikachuEXE/where_lower.svg?style=flat-square)](https://coveralls.io/r/PikachuEXE/where_lower)
[![Code Climate](http://img.shields.io/codeclimate/github/PikachuEXE/where_lower.svg?style=flat-square)](https://codeclimate.com/github/PikachuEXE/where_lower)


## Installation

```ruby
gem 'where_lower'
```


## Usage
Supports `String`, `Array`, `Range`  
Values in `Array` and `Range` will be converted to `String` and then `downcase`  
Other types will not be touched

```ruby
SomeActiveRecordClass.where_lower(attribute1: 'AbC', attribute2: ['stRing', 123, :symBol], attribute3: ('AA'..'AZ'))
```

### Since `0.3.0`
You can pass a nested hash (1 level deep only) for association condition
```ruby
record.association_records.where_lower(association_table: {association_column: value})
```

You can also add table name in key if you are using it with association  
I don't plan to support any "smart" table guessing though
```ruby
record.association_records.where_lower('association_table.association_column' => value)
```


## Contributors
- [Matthew Rudy Jacobs](https://github.com/matthewrudy) (Who wrote the first version of `where_lower` method)
