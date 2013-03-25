module WhereLower
  module Core
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def where_lower(fields)
        fields.is_a?(Hash) or raise AugumentError, 'fields is not a Hash'

        scope = self
        table = self.arel_table

        fields.each do |field_name, value|
          case value
          when Range
            # Performing `BETWEEN` with strings is unpredictable and not supported here
            raise ArgumentError, 'Using Range as value in conditions is not supported'
          when Array # Assume the content to be string, or can be converted to string
            value = value.to_a.map {|x| x.to_s.downcase}
            scope = scope.where(
              table[field_name].lower.in(value)
            )
          when String
            scope = scope.where(
              table[field_name].lower.eq(table.lower(value))
            )
          else # other single value classes
            scope = scope.where(
              table[field_name].eq(value)
            )
          end
        end

        scope
      end
    end
  end
end
