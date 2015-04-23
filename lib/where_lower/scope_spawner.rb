module WhereLower
  class ScopeSpawner
    attr_reader :scope, :column_or_table_name, :value, :prefix

    def self.spawn(*args)
      new(*args).spawn
    end

    def initialize(scope, column_or_table_name, value, prefix = nil)
      @scope                = scope
      @column_or_table_name = column_or_table_name
      @value                = value
      @prefix               = prefix
    end

    # acts as factory
    def spawn
      CLASS_TO_SPAWNER_CLASS_MAPPINGS[value.class].
        spawn(*scope_arguments)
    end

    private

    def scope_arguments
      [scope, column_or_table_name, value, prefix]
    end

    class BasicScopeSpawner < ScopeSpawner
      def spawn
        scope.where(column_name => value)
      end

      private

      def column_name
        [prefix, column_or_table_name].compact.join(SEPERATOR)
      end
    end

    # @abstract
    class EqualScopeSpawner < BasicScopeSpawner
      def spawn
        scope.where(query_string, processed_value)
      end
    end

    class StringScopeSpawner < EqualScopeSpawner
      def query_string
        "lower(#{column_name}) = ?"
      end

      def processed_value
        value.downcase
      end
    end

    class RangeScopeSpawner < EqualScopeSpawner
      def query_string
        "lower(#{column_name}) IN (?)"
      end

      def processed_value
        Range.new(value.begin.to_s.downcase, value.end.to_s.downcase, value.exclude_end?)
      end
    end

    class ArrayScopeSpawner < EqualScopeSpawner
      def query_string
        "lower(#{column_name}) IN (?)"
      end

      def processed_value
        value.to_a.map { |x| x.to_s.downcase }
      end
    end

    class HashScopeSpawner < BasicScopeSpawner
      def spawn
        # If prefix already exists,
        # that means we are in association table already,
        # which cannot accept another hash
        # This gem has no ability to handle deep nested associaiton reflection yet
        fail TooDeepNestedConditions unless prefix.nil?

        value.inject(scope) do |new_scope, (column_name, column_value)|
          ScopeSpawner.spawn(new_scope, column_name, column_value, column_or_table_name)
        end
      end
    end

    CLASS_TO_SPAWNER_CLASS_MAPPINGS = {
      Hash   => HashScopeSpawner,
      String => StringScopeSpawner,
      Range  => RangeScopeSpawner,
      Array  => ArrayScopeSpawner,
    }.tap { |h| h.default = BasicScopeSpawner }.freeze
  end
end
