require 'bunny'
require 'consul'

module Landmark
  class Rabbit
    @mutex = Mutex.new
    class << self
      def connection
        @mutex.synchronize do
          @connection = nil if @connection && @connection.closed?

          @connection ||= begin
            connection = Bunny.new(configuration)
            connection.start
            connection
          end
        end
      end

      def connect
        channel = nil
        connection = self.connection
        @mutex.synchronize do
          channel = connection.create_channel
        end
        yield channel if block_given?
      ensure
        channel.close if channel && channel.open?
      end

      def configuration
        return unless production?

        {}
      end

      def production?
        %w[production staging].include?(ENV['RAKE_ENV'])
      end
    end
  end
end
