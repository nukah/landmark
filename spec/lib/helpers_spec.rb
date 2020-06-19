require 'spec_helper'

describe Lighthouse::Helpers do
  let(:object) { Object.new.extend(Lighthouse::Helpers) }

  describe '.fire_time' do
    subject { object.fire_time(type, interval) }

    context 'at' do
      let(:type) { :at }
      context 'specific date' do
        let(:interval) { '2016-01-10 15:30' }

        it { expect(subject).to eq(Time.new(2016, 1, 10, 15, 30)) }
      end

      context 'specific time' do
        let(:interval) { '0:17' }

        it { expect(subject).to eq(Time.now.change(hour: 0, min: 17)) }
      end
    end

    context 'minute' do
      let(:type) { :minute }
      let(:interval) { 10 }

      it { expect(subject).to eq(10.minutes) }
    end
  end

  describe '.trigger?' do
    subject { object.trigger?(time, type, interval) }

    context '8th minute' do
      let(:time)        { Time.new(2018, 3, 26, 12, 16, 0).to_i }
      let(:type)        { :minute }
      let(:interval)    { 8 }

      it { expect(subject).to be_truthy }
    end

    context '21th minute' do
      let(:time)        { Time.new(2018, 3, 26, 1, 3, 0).to_i }
      let(:type)        { :minute }
      let(:interval)    { 21 }

      it { expect(subject).to be_truthy }
    end

    context '34th minute' do
      let(:time)        { Time.new(2018, 3, 26, 2, 16, 0).to_i }
      let(:type)        { :minute }
      let(:interval)    { 34 }

      it { expect(subject).to be_truthy }

      context 'with invalid time' do
        let(:time)      { Time.new(2018, 3, 26, 12, 14, 0).to_i }

        it { expect(subject).to be_falsey }
      end
    end

    context '10 seconds' do
      let(:time)        { Time.new(2018, 3, 26, 12, 0, 0).to_i }
      let(:type)        { :second }
      let(:interval)    { 10 }

      it { expect(subject).to be_truthy }

      context 'with invalid time' do
        let(:time) { Time.new(2018, 3, 26, 12, 0, 1).to_i }

        it { expect(subject).not_to be_truthy }
      end
    end

    context '1 hour' do
      let(:time)        { Time.new(2018, 3, 26, 12, 0, 0).to_i }
      let(:type)        { :hour }
      let(:interval)    { 1 }

      it { expect(subject).to be_truthy }

      context 'with invalid time' do
        let(:time) { Time.new(2018, 3, 26, 12, 1, 0).to_i }

        it { expect(subject).not_to be_truthy }
      end
    end

    context '2 hours' do
      let(:time)        { Time.new(2018, 3, 26, 12, 0, 0).to_i }
      let(:type)        { :hour }
      let(:interval)    { 2 }

      it { expect(subject).to be_truthy }

      context 'with invalid time' do
        let(:time) { Time.new(2018, 3, 26, 12, 5, 0).to_i }

        it { expect(subject).not_to be_truthy }
      end
    end

    context '6 hours' do
      let(:time)        { Time.new(2018, 3, 26, 12, 0, 0).to_i }
      let(:type)        { :hour }
      let(:interval)    { 6 }

      it { expect(subject).to be_truthy }

      context 'with invalid time' do
        let(:time)       { Time.new(2018, 3, 26, 10, 0, 0).to_i }

        it { expect(subject).not_to be_truthy }
      end
    end

    context '1 week' do
      let(:time)        { Time.new(2019, 7, 15, 0, 0, 0).to_i }
      let(:type)        { :week }
      let(:interval)    { 1 }

      it { expect(subject).to be_truthy }

      context 'with invalid time' do
        let(:time)       { Time.new(2019, 7, 19, 0, 0, 0).to_i }

        it { expect(subject).not_to be_truthy }
      end
    end
  end
end
