module WhereLower
  module Core
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def where_lower(fields)
        fields.is_a?(Hash) or raise AugumentError, 'fields is not a Hash'

        spawn_lower_scope(fields)
      end

      private

      def spawn_lower_scope(fields)
        scope = self
        table = self.arel_table

        fields.each do |name, value|
          scope = spawn_lower_scope_by_type(scope, table, name, value)
        end

        scope
      end

      def spawn_lower_scope_by_type(scope, table, column_name, value)
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
        else #:eq
          "lower(#{column_name}) = ?"
        end
      end
    end
  end
end
