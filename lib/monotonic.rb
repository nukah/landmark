require 'singleton'

module Landmark
  class Monotonic
    include Singleton
    include Helpers
    attr_reader :timers, :mutex

    def initialize
      @timers = Hash.new { |hash, key| hash[key] = [] }
      @mutex = Mutex.new
    end

    def self.stop(interval)
      instance.stop(interval)
    end

    def self.every(type, interval, &block)
      instance.run(type, interval, &block)
    end

    def run(type, interval)
      fire_at = fire_time(type, interval)
      mutex.synchronize do
        timers[fire_at] << Thread.new do
          each do |time|
            yield(time) if trigger?(time, type, interval)
          end
        end
      end
      nil
    end

    def stop(interval)
      seconds = interval.to_i
      mutex.synchronize do
        timers.fetch(seconds) { [] }.each(&:kill)
        timers.delete(seconds)
      end
      nil
    end

    def each
      return enum_for(:each) unless block_given?

      loop do
        yield Process.clock_gettime(Process::CLOCK_REALTIME, :second)
        sleep(1)
      end
    end
  end
end
