module WhereLower
  module ActiveRecordExtension
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def where_lower(fields)
        fields.is_a?(Hash) or raise AugumentError, 'fields is not a Hash'

        WhereLower::Base.spawn_lower_scope(self, fields)
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include ::WhereLower::ActiveRecordExtension
end
