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

        active = archive_select(self, "active")
        active = query.call(active) if query

        archived = archive_select(archive, "archived")
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

      def archive_aged_records(aged_where_sql = ["created_at < ?", 6.months.ago], order_sql = "id ASC", batch_size = 100)
        if archive # not on archive class
          records = nil
          while records.nil? || records.any?
            records = where(aged_where_sql).order(order_sql).limit(batch_size)
            transaction do
              records.each do |instance|
                instance.archive!
              end
            end
          end
        end
      end

      def has_archive_associations(assocs)
        @archive_associations = assocs
      end

      def archive_associations
        @archive_associations ||= []
      end

      private
      def archive_select(model, archive_table_type)
        quoted_table = ActiveRecord::Base.connection.quote_table_name(model.table_name)
        quoted_type = ActiveRecord::Base.connection.quote(archive_table_type)

        attrs = attribute_names.map {|n|
          quoted_attr = ActiveRecord::Base.connection.quote_column_name(n)
          "#{quoted_table}.#{quoted_attr}"
        }

        active = model.select("#{attrs.join(", ")}, #{quoted_type} as archive_table_type")
      end

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

    def archive!
      transaction do
        archived_instance = self.class.archive.new
        attributes.each do |name, value|
          archived_instance.send("#{name}=", value)
        end
        archived_instance.save(validate: false)
        self.class.archive_associations.each do |assoc_name|
          assoc = send(assoc_name)
          if assoc && assoc.respond_to?(:archive!)
            assoc.archive!
          elsif assoc.is_a?(Array) || assoc.is_a?(ActiveRecord::Relation)
            assoc.each do |a|
              a.archive! if a.respond_to?(:archive!)
            end
          end
        end
        delete
      end
    end

  end
end

ActiveRecord::Base.send :include, Archiving::ArchiveTable
