require "where_lower/scope_spawner"

module WhereLower
  # Table name and column name seperator
  # This should never change
  SEPERATOR = ".".freeze

  # Raised when some deeply nested hash passed in which cannot be handled by this gem
  class TooDeepNestedConditions < ArgumentError; end

  # Internal API to be called from extension methods
  module Base
    class << self
      # Spawn a new scope based on existing scope and hash
      # This is method is for internal use
      #
      # @api private
      #
      # @params scope [ActiveRecord::Relation, ActiveRecord::Base]
      #   the existing scope, ActiveRecord::Base also works since `where` will be delegated
      # @params fields [Hash]
      #   @see `.where_lower`
      #
      # @see `.spawn_lower_scope_by_type`
      #
      # @return [ActiveRecord::Relation]
      def spawn_lower_scope(scope, fields)
        fields.inject(scope) do |new_scope, (name, value)|
          spawn_lower_scope_by_type(new_scope, name, value)
        end
      end

      # This is method is for internal use
      #
      # @api private
      #
      # @params scope [ActiveRecord::Relation, ActiveRecord::Base]
      #   @see spawn_lower_scope
      # @params column_or_table_name [String, Symbol]
      #   When used with nested hash, this is table name
      # @params value [Object]
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
