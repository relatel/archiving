require "active_support/concern"

module Archiving
  module ArchiveTable
    extend ActiveSupport::Concern

    included do

    end

    module ClassMethods
      def archive_table
      end
    end
  end
end

ActiveRecord::Base.send :include, Archiving::ArchiveTable
