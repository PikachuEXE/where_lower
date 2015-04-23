require "active_record"
require "where_lower/base"

# :nodoc:
module WhereLower
  # :nodoc:
  module ActiveRecordExtension
    def self.included(base)
      base.extend(ClassMethods)
    end

    # :nodoc:
    module ClassMethods
      # A bit like `where`, but only accept hash, with value of `String`, `Array`, `Range`
      #
      # @api
      #
      # @param fields [Hash]
      #   the conditions in hash, values will be downcase
      #   It could also be a 1 level deep hash so that it can be used in join
      #
      # @example Find user by username case insensitively
      #   User.where_lower(username: param[:name])
      # @example Find user by alias case insensitively
      #   User.join(:aliases).where_lower(aliases:{name: param[:name]})
      #
      # @raise [ArgumentError] when fields is not a Hash
      def where_lower(fields)
        fail AugumentError, "fields is not a Hash" unless fields.is_a?(Hash)

        WhereLower::Base.spawn_lower_scope(self, fields)
      end
    end
  end
end

# Automagically include the module on require
ActiveRecord::Base.class_eval do
  include ::WhereLower::ActiveRecordExtension
end
