# Run with: rake environment elasticsearch:reindex
# Begins by creating the index using tire:import:model command. This will create the "official" index name, e.g. "things" each time.
# Then we rename it to, e.g. "things_20121001052916" and alias "things" to it.
# Assumes usage of the elasticsearch-ruby libraries
# TODO: Assumes you have a library called ElasticsearchAdminHelper defined with the right methods. Move that helper into this gem

if defined?(Rails)
  namespace :elasticsearch do
    desc 'Reindexes all ActiveRecord model indices'
    task "reindex:all" => :environment do
      Rails.application.eager_load!
      include ElasticsearchAdminHelper

      ActiveRecord::Base.descendants.each do |model_class|
        next unless model_class.respond_to? :__elasticsearch__
        reindex_model(model_class)
      end

      puts 'All indices reindexed'
    end

    desc 'Deletes indices and then reindexes all ActiveRecord model indices assuming none exist yet'
    task "reindex:all:fresh" => :environment do
      return unless Rails.env.development? or Rails.env.test?

      Rails.application.eager_load!
      include ElasticsearchAdminHelper

      # If we don't create the temporary indices, then mass emails (for example) will try
      # to query users for recipient count and fail
      ActiveRecord::Base.descendants.each do |model_class|
        next unless model_class.respond_to? :__elasticsearch__
        delete_index(model_class.index_name)
        create_temporary_index(model_class)
      end

      ActiveRecord::Base.descendants.each do |model_class|
        next unless model_class.respond_to? :__elasticsearch__
        reindex_model(model_class, true)
      end

      puts 'All indices created, aliased and ready'
    end

    desc 'Deletes indices and then reindexes all ActiveRecord model indices assuming none exist yet. Is used for testing where aliases are not used'
    task "tests:prepare" => :environment do
      return unless Rails.env.development? or Rails.env.test?

      Rails.application.eager_load!
      include ElasticsearchAdminHelper

      # If we don't create the temporary indices, then mass emails (for example) will try
      # to query users for recipient count and fail
      ActiveRecord::Base.descendants.each do |model_class|
        next unless model_class.respond_to? :__elasticsearch__
        delete_index(model_class.index_name)
        create_temporary_index(model_class)
      end

      puts 'All indices created, aliased and ready'
    end

    Dir.foreach("#{Rails.root}/app/models") do |item|
      next if item == '.' or item == '..' or not item
      name = item.split(".")[0].pluralize

      desc "Reindexes #{name} using aliases"
      task "reindex:#{name}" => :environment do
        Rails.application.eager_load!
        include ElasticsearchAdminHelper

        klass = Kernel.const_get(name.classify)
        reindex_model(klass)
      end

      desc "Reindexes #{name} using aliases, and deletes the old one first" # because Tire tries to create an index for us sometimes
      task "reindex:#{name}:delete_old_first" => :environment do
        Rails.application.eager_load!
        include ElasticsearchAdminHelper

        klass = Kernel.const_get(name.classify)
        reindex_model(klass, true)
      end
    end
  end
end
