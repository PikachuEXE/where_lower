require 'active_record'
require 'where_lower/version'
require 'where_lower/base'

ActiveRecord::Base.send(:include, WhereLower::Base)
