require "active_support/concern"

module Archiving
  module ArchiveTable
    extend ActiveSupport::Concern

    included do

    end

    module ClassMethods
      attr_accessor :archive_table

      def has_archive_table
        model = Object.const_get(name)
        archive = model.const_set("Archive", Class.new(model))
        archive.table_name = "#{table_name}_archive"
      end
    end
  end
end

ActiveRecord::Base.send :include, Archiving::ArchiveTable
