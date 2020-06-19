require 'landmark'
module Landmark
  def self.run
    Lightbulb.supervise(as: :landmark)
    Celluloid::Actor[:landmark].start
  end
end

Landmark.run
