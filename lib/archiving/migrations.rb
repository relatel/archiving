require "active_support/concern"

module Archiving
  module Migrations
    extend ActiveSupport::Concern

    included do
      def create_archive_table(table)
        active_table = quote_table_name(table)
        archive_table = quote_table_name("#{table}_archive")

        execute("CREATE TABLE IF NOT EXISTS #{archive_table} LIKE #{active_table}")
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::SchemaStatements.send :include, Archiving::Migrations
