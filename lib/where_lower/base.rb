module WhereLower
  module Base
    class << self
      def spawn_lower_scope(scope, fields)
        fields.each do |name, value|
          scope = spawn_lower_scope_by_type(scope, name, value)
        end

        scope
      end

      def spawn_lower_scope_by_type(scope, column_name, value)
        case value
        when Range
          value = Range.new(value.begin.to_s.downcase, value.end.to_s.downcase, value.exclude_end?)
          scope = scope.where(
            lower_query_string(column_name, :in), value
          )
        when Array # Assume the content to be string, or can be converted to string
          value = value.to_a.map {|x| x.to_s.downcase}
          scope = scope.where(
            lower_query_string(column_name, :in), value
          )
        when String
          value = value.downcase
          scope = scope.where(
            lower_query_string(column_name), value
          )
        else # other single value classes
          scope = scope.where(column_name => value)
        end

        scope
      end

      # @param column_name [String/Symbol] name of column
      # @param type [Symbol] :in or :eq
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
