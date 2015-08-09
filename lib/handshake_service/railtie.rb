require 'handshake_service'
require 'rails'

module HandshakeService

  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.expand_path("lib/tasks/*.rake", File.dirname(__FILE__))].each { |ext| load ext }
    end
  end
end
