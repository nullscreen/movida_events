# frozen_string_literal: true

module MovidaEvents
  # Tracks polling stats
  class Stats
    # The last-processed event ID
    #
    # `nil` if no events have been processed
    #
    # @return [Integer,nil] The event ID
    attr_reader :last

    # The number of requests made to the API
    #
    # @return [Integer] The request count
    attr_reader :requests

    # The number of events processed
    #
    # @return [Integer] The event count
    attr_reader :events

    # The number of events processed in the current request
    #
    # @return [Integer] The request event count
    attr_reader :request_events

    # Create a new `MovidaEvents::Stats` object
    #
    # @param last [Integer,nil] The last-processed event ID.
    def initialize(last = nil)
      @last = last
      @requests = 0
      @events = 0
      @request_events = 0
    end

    # Update stats when an event is received
    #
    # @param event [Almodovar::Resource] The event received
    def receive_event(event)
      @last = event.id
      @events += 1
      @request_events += 1
    end

    # Update stats when a new request is started
    def start_request
      @requests += 1
      @request_events = 0
    end
  end
end
