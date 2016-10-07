# frozen_string_literal: true

module MovidaEvents
  # The interface to the Movida event stream API
  #
  # Manages authentication and API configuration
  class Client
    # Create a new `MovidaEvents::Client`
    #
    # @param [Hash] options API setup options
    # @option options [String] :username The username to authenticate with
    #   Required.
    # @option options [String] :password The password to authenticate with.
    #   Required.
    # @option options [String] :domain The API domain to use. Default:
    #   'movida.bebanjo.net'.
    def initialize(options = {})
      @options = default_options.merge(options)
      @auth = Almodovar::DigestAuth.new(
        @options[:realm],
        @options[:username],
        @options[:password]
      )
    end

    # Request a list of events
    #
    # @param [Hash] params Request parameters
    # @option params [String] newer_than An event ID indicating the position in
    #   the event stream where the request starts.
    # @option params [String] event_type A comma separated list of event types.
    # @yield Each returned event
    # @yieldparam event [Almodovar::Resource] The event object
    # @return [Enumerator<Almodovar::Resource>] An enumerator over the returned
    #   events
    def events(params = {}, &block)
      Enumerator.new do |yielder|
        events = events_collection(params)
        events.each { |e| yielder << e }
      end.each(&block)
    end

    private

    # Get a `Almodovar::ResourceCollection` of events
    #
    # @param [Hash] params Request parameters, see {#events}.
    def events_collection(params)
      Almodovar::ResourceCollection.new(
        api_url,
        @auth,
        nil,
        params
      )
    end

    # Get the events API URL
    def api_url
      "https://#{@options[:domain]}/api/events"
    end

    # Get the default options for {#initialize}
    def default_options
      {
        realm: 'realm',
        username: nil,
        password: nil,
        domain: 'movida.bebanjo.net'
      }
    end
  end
end
