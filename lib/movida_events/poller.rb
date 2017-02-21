# frozen_string_literal: true

module MovidaEvents
  # Polls for events and calls a method for each one
  class Poller
    # Indicates if the stop method has been called.
    #
    # @see #stop
    # @return [Boolean] True if the poller is stopped
    attr_reader :stopped

    # Create a new `MovidaEvents::Poller` object
    #
    # @param client [Client] The client for making API requests
    # @param options [Hash] Configuration options
    # @option options [Integer] :newer_than Requests events that occur
    #   only after the given ID
    # @option options [String,Array<String>] :event_type Filter by only the
    #   given event types
    def initialize(client, options = {})
      @client = client
      @options = default_options.merge(options)
      @stopped = false
    end

    # Set a callback to run whenever an API request is made
    #
    # Only one callback may be set
    #
    # @yield Every time a poll request is made
    # @yieldparam stats [Stats] The current stats
    def on_poll(&block)
      @on_poll = block
    end

    # Poll for events
    #
    # This method continues infinitely unless `times` is set.
    #
    # @param times [Integer,nil] If set, polling stops after `times` requests.
    # @yield Every new event
    # @yieldparam event [Almodovar::Resource] The event object
    # @yieldparam stats [Stats] The current stats
    def poll(times = nil)
      stats = initial_stats
      repeat(times) do
        before_request(stats)
        @client.events(request_params(stats)) do |event|
          stats.receive_event(event)
          yield event, stats.clone if block_given?
        end
        break if @stopped
        sleep @options[:interval] if stats.request_events.zero?
      end
    end

    # Stop the poller
    #
    # When this is called, the poller will finish processing the current request
    # and any associated events before stopping.
    def stop
      @stopped = true
    end

    private

    # Repeat times or forever
    #
    # @param times [Integer,nil] The number of times to repeat, or nil for
    #   infinite
    # @yield `times` times or forever
    def repeat(times)
      times ? times.times { yield } : loop { yield }
    end

    # Builds the params for events requests
    #
    # The last event from stats determines where to start for the next API
    # request
    #
    # @param stats [Stats] The current stats
    # @return [Hash] The request params
    def request_params(stats)
      {
        newer_than: stats.last,
        event_type: event_types
      }
    end

    # Builds the event types parameter
    #
    # Converts the `event_types` option into a string
    # @return [String] The stringified events param
    def event_types
      types = @options[:event_types]
      types.is_a?(Array) ? types.join(',') : types
    end

    # Before each request, updates stats and calls `on_poll`.
    #
    # @param stats [Stats] The current stats
    def before_request(stats)
      stats.start_request
      @on_poll.call(stats.clone) if @on_poll
    end

    # Sets up the initial stats state before polling
    #
    # If `newer_than` is not set, gets the latest event ID
    #
    # @return [Stats] The initial stats
    def initial_stats
      Stats.new(@options[:newer_than] || latest_id)
    end

    # Get the most recent event ID from the API
    #
    # The default behavior of the events API if given no parameters is to
    # return the last 50 events. So we select the last event from those.
    #
    # @return [Integer] The most recent event ID
    def latest_id
      @client.events.to_a.last.id
    end

    # Get the default poller options
    #
    # @return [Hash] The default options
    def default_options
      {
        newer_than: nil,
        interval: 30
      }
    end
  end
end
