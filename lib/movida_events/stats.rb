# frozen_string_literal: true

module MovidaEvents
  class Stats
    attr_reader :last, :requests, :events, :request_events

    def initialize(last = nil)
      @last = last
      @requests = 0
      @events = 0
      @request_events = 0
    end

    def receive_event(event)
      @last = event.id
      @events += 1
      @request_events += 1
    end

    def start_request
      @requests += 1
      @request_events = 0
    end
  end
end
