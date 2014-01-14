module WhereLower
  class TooDeepNestedConditions < ArgumentError; end

  module Base
    SEPERATOR = '.'.freeze

    class << self
      def spawn_lower_scope(scope, fields, prefix = nil)
        fields.each do |name, value|
          scope = spawn_lower_scope_by_type(scope, name, value, prefix)
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
      def spawn_lower_scope_by_type(scope, column_or_table_name, value, prefix = nil)
        column_or_table_name = [prefix, column_or_table_name].compact.join(SEPERATOR)

        case value
        when Hash
          if prefix.nil?
            table_name = column_or_table_name
            fields = value
            scope = spawn_lower_scope(scope, fields, table_name)
          else
            # If prefix already exists, that means we are in association table already, which cannot accept another hash
            # This gem has no ability to handle deep nested associaiton reflection yet
            raise TooDeepNestedConditions
          end
        when Range
          value = Range.new(value.begin.to_s.downcase, value.end.to_s.downcase, value.exclude_end?)
          scope = scope.where(
            lower_query_string(column_or_table_name, :in), value
          )
        when Array # Assume the content to be string, or can be converted to string
          value = value.to_a.map {|x| x.to_s.downcase}
          scope = scope.where(
            lower_query_string(column_or_table_name, :in), value
          )
        when String
          value = value.downcase
          scope = scope.where(
            lower_query_string(column_or_table_name), value
          )
        else # other single value classes
          scope = scope.where(column_or_table_name => value)
        end

        scope
      end

      # @param [String/Symbol] column_name name of column
      # @param [Symbol] type :in or :eq
      def lower_query_string(column_name, type = :eq)
        case type
        when :in
          "lower(#{column_name}) IN (?)"
        when :eq
          "lower(#{column_name}) = ?"
        else
          raise ArgumentError
        end
      end
    end
  end
end
