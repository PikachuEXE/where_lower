module WhereLower
  SEPERATOR = '.'.freeze

  class TooDeepNestedConditions < ArgumentError; end

  module Base
    class << self
      # @params [ActiveRecord::Relation, ActiveRecord::Base] scope
      # @params [Hash] fields
      def spawn_lower_scope(scope, fields)
        fields.each do |name, value|
          scope = spawn_lower_scope_by_type(scope, name, value)
        end

        scope
      end

      # @params [ActiveRecord::Relation, ActiveRecord::Base] scope
      # @params [String, Symbol] column_or_table_name When used with nested hash, this is table name
      # @params [Object] value
      # @params [String, Symbol] prefix used when doing recursive call
      #
      # @raise [TooDeepNestedConditions] if the conditions hash has is too deep nested
      #
      # @return [ActiveRecord::Relation]
      def spawn_lower_scope_by_type(scope, column_or_table_name, value)
        ScopeSpawner.spawn(scope, column_or_table_name, value)
      end
    end
  end
end
