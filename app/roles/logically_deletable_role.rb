module LogicallyDeletableRole
  class << self
    def included(klass)
      klass.class_eval do
        include InstanceMethods

        scope :without_deleted, ->() {
          where("#{table_name}.deleted_at IS NULL")
        }
        scope :deleted, ->() {
          where("#{table_name}.deleted_at IS NOT NULL")
        }
      end

      klass.extend ClassMethods
    end
  end

  class NotLogicallyDeletable < RuntimeError; end

  module ClassMethods
  end

  module InstanceMethods
    def deleted?
      !!deleted_at
    end

    def delete_logically
      raise NotLogicallyDeletable.new(
        "`deleted_at' column is required to be logically deleted"
      ) unless respond_to?(:deleted_at)

      update(deleted_at: Time.now)
    end

    def destroy
      delete_logically
    end
  end
end
