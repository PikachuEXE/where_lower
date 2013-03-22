require 'active_record'
require 'where_lower/version'
require 'where_lower/core'

ActiveRecord::Base.send(:include, WhereLower::Core)
