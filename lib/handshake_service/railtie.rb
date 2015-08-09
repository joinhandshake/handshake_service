module HandshakeService
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/deploy.rake'
      Dir[File.expand_path("tasks/*.rake", File.dirname(__FILE__))].each { |ext|
        puts ext
        puts load ext
      }
    end
  end
end
