# frozen_string_literal: true

RSpec.describe MovidaEvents::Client do
  let(:title_event) do
    %(
      <events type="array">
        <event>
          <id type="integer">1234</id>
          <event-type>title_created</id>
          <timestamp type="datetime">2016-08-14T17:40:01+02:00</timestamp>
          <changes>name</changes>
          <link rel="self" href="https://movida.bebanjo.net/api/events/1234"/>
          <link rel="subject" href="https://movida.bebanjo.net/api/titles/876"/>
        </event>
      </events>
    )
  end

  it 'authenticates with username and password' do
    stub = stub_request(:get, 'https://movida.bebanjo.net/api/events')
      .to_return(body: '<events type="array"></events>')

    expect(Almodovar::ResourceCollection).to receive(:new)
      .with(
        'https://movida.bebanjo.net/api/events',
        Almodovar::DigestAuth.new('realm', 'foo', 'bar'),
        nil,
        {}
      )
      .and_call_original

    described_class.new(username: 'foo', password: 'bar').events.to_a
    expect(stub).to have_been_requested
  end

  it 'uses the given domain' do
    stub = stub_request(:get, 'https://staging-movida.bebanjo.net/api/events')
      .to_return(body: '<events type="array"></events>')

    described_class.new(domain: 'staging-movida.bebanjo.net').events.to_a
    expect(stub).to have_been_requested
  end

  it 'gets an Enumerator of Event resources' do
    stub = stub_request(:get, 'https://movida.bebanjo.net/api/events')
      .to_return(body: title_event)

    events = described_class.new.events
    expect(events).to be_a(Enumerator)

    array = events.to_a

    expect(array.size).to eq(1)
    expect(array[0].id).to eq(1234)
    expect(stub).to have_been_requested
  end

  it 'accepts a block to run for each event' do
    stub = stub_request(:get, 'https://movida.bebanjo.net/api/events')
      .to_return(body: title_event)

    yielded = []
    described_class.new.events do |event|
      yielded << event
    end

    expect(yielded.size).to eq(1)
    expect(yielded[0].id).to eq(1234)
    expect(stub).to have_been_requested
  end

  it 'uses request options' do
    stub = stub_request(:get, 'https://movida.bebanjo.net/api/events')
      .with(query: {
        'newer_than' => '1234',
        'event_types' => 'title_created,title_updated'
      })
      .to_return(body: '<events type="array"></events>')

    described_class.new.events(
      newer_than: 1234,
      event_types: 'title_created,title_updated'
    ).to_a
    expect(stub).to have_been_requested
  end
end
