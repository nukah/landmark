require 'celluloid/current'

module Landmark
  class Lightbulb
    include Celluloid
    include Helpers

    SCHEDULE = {
      second: [1, 3, 5, 10, 15, 30, 45],
      minute: [1, 2, 3, 5, 8, 13, 21, 34, 57],
      hour: [1, 2, 3, 6],
      day: [1],
      week: [1],
      at: ['0:00', '0:17', '12:00', '1:00', '2:00', '3:00', '4:00', '5:00',
           '6:00', '7:00', '8:00', '9:00', '10:00', '11:00', '12:00', '13:00',
           '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00',
           '21:00', '22:00', '22:50', '23:00']
    }.freeze

    def self.start
      new.start
    end

    def start
      SCHEDULE.each do |type, intervals|
        intervals.each { |interval| create_timer(type, interval) }
      end
      Monotonic.instance.timers.values.flatten.map(&:join)
    end

    def create_timer(type, interval)
      route = routing_key(type, interval)
      Monotonic.every(type, interval) do |time|
        publish(route, time)
      end
    end

    private

    def publish(route, time)
      exchange do |exchange|
        logger.info "Pushing #{route} with #{time}"
        exchange.publish({ timestamp: time.to_i, interval: route }.to_json,
                         routing_key: route,
                         persistent: false)
      end
    rescue StandardError => exc
      logger.error("Error: #{exc.message}")
      raise exc
    end

    def exchange_name
      'landmark.timers'
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
