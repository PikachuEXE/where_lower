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
          scope = scope.where(
            table[field_name].lower.eq(table.lower(value))
          )
        end

        scope
      end
    end
  end
end
