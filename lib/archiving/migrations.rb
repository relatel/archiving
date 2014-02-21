require "active_support/concern"

module Archiving
  module Migrations
    extend ActiveSupport::Concern

    included do
      def create_archive_table(table)
        active_table = quote_table_name(table)
        archive_table = quote_table_name("#{table}_archive")

        create_sql = "CREATE TABLE #{archive_table} LIKE #{active_table}"

        execute(create_sql)
      end
    end

    module ClassMethods
    end
  end
end

ActiveRecord::ConnectionAdapters::SchemaStatements.send :include, Archiving::Migrations
