require "active_support/concern"
require "active_support/inflector"

module Archiving
  module ArchiveTable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :archive_table

      def has_archive_table
        model = name.constantize
        @archive_model = model.const_set("Archive", Class.new(model))
        @archive_model.after_initialize do |record|
          record.readonly! unless record.new_record?
        end
        @archive_model.table_name = "#{table_name}_archive"
      end

      def archive
        @archive_model
      end

      def with_archive(query = nil, order: nil, limit: nil, offset: nil)
        active = select_archive_attributes_for(self, archive_table_type: "active")
        active = query.call(active) if query

        archived = select_archive_attributes_for(archive, archive_table_type: "archived")
        archived = query.call(archived) if query

        sql = "(#{active.to_sql}) UNION (#{archived.to_sql})"

        if order
          sql << sanitize_sql([" ORDER BY %s", order])
        end
        if limit
          sql << sanitize_sql([" LIMIT %s", limit])
        end
        if offset
          sql << sanitize_sql([" OFFSET %s", offset])
        end

        find_active_and_archived_by_sql(sql)
      end

      def archive_aged_records(where: ['created_at < ?', 6.months.ago], order: :id, batch_size: 100, before_callback: nil)
        return unless archive

        records = nil
        while records.nil? || records.any?
          before_callback.call if before_callback

          records = self.where(where).order(order).limit(batch_size)
          transaction do
            records.each(&:archive!)
          end
        end
      end

      attr_reader :archive_associations

      def has_archive_associations(associations)
        @archive_associations = associations
      end

      private
        def select_archive_attributes_for(relation, archive_table_type: nil)
          quoted_type = connection.quote(archive_table_type)

          relation.select(attribute_names).select("#{quoted_type} as archive_table_type")
        end

        def find_active_and_archived_by_sql(sql)
          connection.select_all(sanitize_sql(sql), "#{name} Union Load").map do |record|
            model = record["archive_table_type"] == 'archived' ? archive : self
            model.instantiate(record)
          end
        end
    end

    def archive!
      if archive_with_transaction?
        transaction do
          archive_me!
        end
      else
        archive_me!
      end
    end

    private
      def archive_me!
        self.class.archive.new.tap do |archive|
          attributes.each { |k, v| archive[k] = v }
          raise "Unarchivable attributes" if archive.attributes != attributes
          archive.save!(validate: false)
        end

        archive_associations!
        delete
      end

      def archive_associations!
        Array(self.class.archive_associations).each do |assoc_name|
          next unless association = send(assoc_name)
          if association.respond_to?(:archive!)
            association.send(:archive_me!)
          elsif association.respond_to?(:each)
            association.each do |assoc|
              assoc.respond_to?(:archive!) && assoc.send(:archive_me!)
            end
          end
        end
      end

      def archive_with_transaction?
        archive_connection_configs.size == 1
      end

      def archive_connection_configs
        configs = Set.new
        configs << self.class.connection_config
        if respond_to?(:archive!)
          Array(self.class.archive_associations).each do |assoc_name|
            next unless association = send(assoc_name)
            if association.respond_to?(:archive!)
              configs.merge association.send(:archive_connection_configs)
            elsif association.respond_to?(:each)
              association.each do |assoc|
                if assoc.respond_to?(:archive!)
                  configs.merge assoc.send(:archive_connection_configs)
                end
              end
            end
          end
        end
        configs
      end
  end
end
