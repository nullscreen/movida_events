# frozen_string_literal: true

module MovidaEvents
  class Poller
    def initialize(client, options = {})
      @client = client
      @options = default_options.merge(options)
    end

    def before_poll(&block)
      @before_poll = block
    end

    def poll(times = nil)
      stats = initial_stats
      repeat(times) do
        before_request(stats)
        @client.events(request_params(stats)) do |event|
          stats.receive_event(event)
          yield event, stats.clone if block_given?
        end
        sleep @options[:interval] if stats.request_events.zero?
      end
    end

    private

    def repeat(times)
      times ? times.times { yield } : loop { yield }
    end

    def request_params(stats)
      {
        newer_than: stats.last,
        event_type: event_types
      }
    end

    def event_types
      types = @options[:event_types]
      types.is_a?(Array) ? types.join(',') : types
    end

    def before_request(stats)
      stats.start_request
      @before_poll.call(stats.clone) if @before_poll
    end

    def initial_stats
      Stats.new(@options[:newer_than] || latest_id)
    end

    def latest_id
      @client.events.to_a.last.id
    end

    def default_options
      {
        newer_than: nil,
        interval: 30
      }
    end
  end
end
