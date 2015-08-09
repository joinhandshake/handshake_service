module HandshakeService
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.expand_path("lib/tasks/*.rake", File.dirname(__FILE__))].each { |ext|
        puts ext
        puts load ext
      }
    end
  end
end
