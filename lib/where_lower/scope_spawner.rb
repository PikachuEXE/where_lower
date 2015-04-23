module WhereLower
  # :nodoc:
  class ScopeSpawner
    # :nodoc:
    attr_reader :scope, :column_or_table_name, :value, :prefix

    # Spawn different scopes based on value
    # Just delegates to new though
    #
    # @param args [Array] arguments that are passed to #initialize
    #
    # @see #initialize
    def self.spawn(*args)
      new(*args).spawn
    end

    # Assign ivar only
    # Actual operation is in #spawn
    #
    # @param scope [ActiveRecord::Relation]
    #   Relation or collection proxy or some AR classes
    # @param column_or_table_name [Symbol, String]
    #   when column name, the actual column name (not attribute name)
    #   when table name, the actual table name (not class name converted to underscore)
    # @param value [Object]
    #   value to compare to, also determine what scope spawner to be used
    # @param prefix [Symbol, String]
    #   used internally for specifying a scope with prefix (table name)
    #
    # @see #spawn
    def initialize(scope, column_or_table_name, value, prefix = nil)
      @scope                = scope
      @column_or_table_name = column_or_table_name
      @value                = value
      @prefix               = prefix
    end

    # Spawn different scopes based on value
    # Data conversion and query string generation are handled by different spanwer classes
    #
    # @return [ActiveRecord::Relation] Relation or collection proxy or some AR classs
    def spawn
      CLASS_TO_SPAWNER_CLASS_MAPPINGS[value.class].
        spawn(*scope_arguments)
    end

    private

    # :nodoc:
    def scope_arguments
      [scope, column_or_table_name, value, prefix]
    end

    # :nodoc:
    class BasicScopeSpawner < ScopeSpawner
      # :nodoc:
      def spawn
        scope.where(column_name => value)
      end

      private

      # :nodoc:
      def column_name
        [prefix, column_or_table_name].compact.join(SEPERATOR)
      end
    end

    # This class is only for inheritance
    #
    # @abstract
    #   Subclass has to implement #query_string & #processed_value
    class EqualScopeSpawner < BasicScopeSpawner
      # We generate query_string and pass values to it
      # To avoid some scope chaining problems
      def spawn
        scope.where(query_string, processed_value)
      end
    end

    # :nodoc:
    class StringScopeSpawner < EqualScopeSpawner
      # :nodoc:
      def query_string
        "lower(#{column_name}) = ?"
      end

      # :nodoc:
      def processed_value
        value.downcase
      end
    end

    # :nodoc:
    class RangeScopeSpawner < EqualScopeSpawner
      # :nodoc:
      def query_string
        "lower(#{column_name}) IN (?)"
      end

      # :nodoc:
      def processed_value
        Range.new(value.begin.to_s.downcase, value.end.to_s.downcase, value.exclude_end?)
      end
    end

    # :nodoc:
    class ArrayScopeSpawner < EqualScopeSpawner
      # :nodoc:
      def query_string
        "lower(#{column_name}) IN (?)"
      end

      # :nodoc:
      def processed_value
        value.to_a.map { |x| x.to_s.downcase }
      end
    end

    # :nodoc:
    class HashScopeSpawner < BasicScopeSpawner
      # If prefix already exists,
      # that means we are in association table already,
      # which cannot accept another hash
      # This gem has no ability to handle deep nested associaiton reflection yet
      def spawn
        fail TooDeepNestedConditions unless prefix.nil?

        value.inject(scope) do |new_scope, (column_name, column_value)|
          ScopeSpawner.spawn(new_scope, column_name, column_value, column_or_table_name)
        end
      end
    end

    # This was extracted from `case..when`
    CLASS_TO_SPAWNER_CLASS_MAPPINGS = {
      Hash   => HashScopeSpawner,
      String => StringScopeSpawner,
      Range  => RangeScopeSpawner,
      Array  => ArrayScopeSpawner,
    }.tap { |h| h.default = BasicScopeSpawner }.freeze
  end
end
