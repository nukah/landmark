module Landmark
  module Helpers
    def fire_time(type, interval)
      case type
      when :at then interval.public_send(:in_time_zone)
      else interval.public_send(type)
      end
    end

    def trigger?(time, type, interval)
      case type
      when :at then Time.at(time) == fire_time(type, interval)
      when :week
        time_object = Time.at(time).beginning_of_day
        ((time_object - time_object.beginning_of_week) % fire_time(type, interval)).zero?
      else
        time_object = Time.at(time)
        ((time_object - time_object.beginning_of_day) % fire_time(type, interval)).zero?
      end
    end

    def routing_key(type, interval)
      case type
      when :at then [type, interval].join('_').sub(':', '_')
      else [interval, type].join
      end
    end

    def connection
      Rabbit.connect { |channel| yield(channel) }
    end

    def exchange
      connection do |channel|
        yield(channel.direct(exchange_name, durable: false))
      end
    end
  end
end
