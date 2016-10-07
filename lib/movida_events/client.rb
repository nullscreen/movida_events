# frozen_string_literal: true

module MovidaEvents
  class Client
    def initialize(options = {})
      @options = default_options.merge(options)
      @auth = Almodovar::DigestAuth.new(
        @options[:realm],
        @options[:username],
        @options[:password]
      )
    end

    def events(opts = {}, &block)
      Enumerator.new do |yielder|
        events = events_collection(opts)
        events.each { |e| yielder << e }
      end.each(&block)
    end

    private

    def events_collection(opts)
      Almodovar::ResourceCollection.new(
        api_url(['events']),
        @auth,
        nil,
        opts
      )
    end

    def api_url(path = [])
      "https://#{@options[:domain]}/api/#{path.join('/')}"
    end

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
