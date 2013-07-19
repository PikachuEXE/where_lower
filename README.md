where_lower
===========

Provide an easy way to use case insensitive `where` in ActiveRecord.

### Support
===========
Tested against:
- Active Record of version `3.1`, `3.2` and `4.0`
- Ruby `1.9.2`, `1.9.3`, `2.0.0` (except Rails 4 with `1.9.2`)

[![Build Status](https://travis-ci.org/PikachuEXE/where_lower.png?branch=master)](https://travis-ci.org/PikachuEXE/where_lower)
[![Gem Version](https://badge.fury.io/rb/where_lower.png)](http://badge.fury.io/rb/where_lower)

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

Contributors
============
[Matthew Rudy Jacobs](https://github.com/matthewrudy) (Who wrote the first version of `where_lower` method)
