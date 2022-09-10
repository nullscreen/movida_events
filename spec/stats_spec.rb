# frozen_string_literal: true

RSpec.describe MovidaEvents::Stats do
  it 'has default values' do
    stats = described_class.new
    expect(stats.last).to be_nil
    expect(stats.events).to eq(0)
    expect(stats.requests).to eq(0)
    expect(stats.request_events).to eq(0)
  end

  it 'initializes last to the given value' do
    stats = described_class.new(1234)
    expect(stats.last).to eq(1234)
  end

  it 'adjusts stats for received events' do
    stats = described_class.new(1234)
    event = double('Almodovar::SingleResource', id: 5678) # rubocop:disable RSpec/VerifiedDoubles
    stats.receive_event(event)
    expect(stats.last).to eq(5678)
    expect(stats.events).to eq(1)
    expect(stats.request_events).to eq(1)
  end

  it 'adjust stats when starting a request' do
    stats = described_class.new
    event = double('Almodovar::SingleResource', id: 5678) # rubocop:disable RSpec/VerifiedDoubles
    stats.receive_event(event)
    stats.start_request
    expect(stats.request_events).to eq(0)
    expect(stats.requests).to eq(1)
  end
end
