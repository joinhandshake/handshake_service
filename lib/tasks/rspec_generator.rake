# Finds missing rspec files and generates them for you. May take a while to run, depending
# on the number of scaffolds in the project.
if defined?(Rails)
  namespace :rspec_generator do
    desc 'Generate rspec specs for all scaffolds that are missing specs'
    task :generate => :environment do
      Rails.application.eager_load!

      # Iterate over all 'normal' active record classes. By normal
      # I mean that rails includes habtm join tables in the list
      # which we don't want.
      ActiveRecord::Base.descendants.each do |model_class|
        next if model_class.name.starts_with?("HABTM_")
        generate_for_model(model_class)
      end
    end

    def generate_for_model(model_class)
      underscore_name = model_class.name.underscore
      puts "Generating missing specs for #{underscore_name}"
      system("rails g rspec:scaffold #{underscore_name} -s --view-specs=false --controller-specs=false --request-specs=true")
      system("rails g rspec:model #{underscore_name} -s")
    end
  end
end
