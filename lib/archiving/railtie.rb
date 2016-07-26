require 'rails'

module Archiving
  class Railtie < ::Rails::Railtie
    initializer 'archiving.install' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.include ArchiveTable
        ActiveRecord::ConnectionAdapters::SchemaStatements.include Migrations
      end
    end
  end
end
