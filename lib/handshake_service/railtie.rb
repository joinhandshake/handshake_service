require 'handshake_service'

module HandshakeService
  require 'rails'

  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/auto_annotate_models.rake"
      load "tasks/deploy.rake"
      load "tasks/elasticsearch.rake"
      load "tasks/heroku.rake"
      load "tasks/invalids.rake"
      load "tasks/rspec_generator.rake"
    end
  end
end
