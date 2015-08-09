require 'handshake_service'

module HandshakeService
  require 'rails'

  class Railtie < Rails::Railtie
    rake_tasks { load "tasks/paperclip.rake" }
  end
end
