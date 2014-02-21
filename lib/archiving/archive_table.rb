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
        @archive_model = model.const_set("Archive", Class.new(model))
        @archive_model.after_initialize do |record|
          record.readonly! unless record.new_record?
        end
        @archive_model.table_name = "#{table_name}_archive"
      end

      def archive
        @archive_model
      end

      def with_archive(query_or_options={}, options={})
        if query_or_options.is_a?(Hash)
          options = query_or_options
        else
          query = query_or_options
        end

        attrs = attribute_names.sort.join(", ")

        active = select("#{attrs}, 'active' as archive_table_type")
        active = query.call(active) if query

        archived = archive.select("#{attrs}, 'archived' as archive_table_type")
        archived = query.call(archived) if query

        sql = "(#{active.to_sql}) UNION (#{archived.to_sql})"

        if options[:order]
          sql += sanitize_sql([" ORDER BY %s", options[:order]])
        end
        if options[:limit]
          sql += sanitize_sql([" LIMIT %s", options[:limit]])
        end
        if options[:offset]
          sql += sanitize_sql([" OFFSET %s", options[:offset]])
        end

        find_active_and_archived_by_sql(sql)
      end

      private
      def find_active_and_archived_by_sql(sql)
        logging_query_plan do
          result = connection.select_all(send(:sanitize_sql, sql), "#{name} Union Load")   
          result.map {|record|
            case record["archive_table_type"]
            when "active"
              instantiate(record)
            when "archived"
              archive.instantiate(record)
            end 
          }   
        end 
      end
    end
  end
end

ActiveRecord::Base.send :include, Archiving::ArchiveTable
