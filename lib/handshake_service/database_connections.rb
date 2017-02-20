# A slight abstraction on top of various gems and libraries for
# primary/replica setups. Goal is to make it easier to manager the interface
# between Handshake and the gem, and make changes in the future easier
# to reason about.
#
# Current implementation: Knockoff gem
module HandshakeService
  module DatabaseConnections
    def self.enabled?
      Knockoff.enabled
    end

    def self.with_primary(&block)
      Knockoff.on_primary(&block)
    end

    def self.with_replicas(&block)
      Knockoff.on_replica(&block)
    end
  end
end
