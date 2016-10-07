# MovidaEvents

Watches the movida event stream and calls your code for each event.

## Installation

Add this line to your application's `Gemfile`. Substitute the current tag name.

```ruby
gem 'movida_events', git: 'ssh@bitbucket.org:machinima-dev/movida-events.git', tag: '0.1.0'
```

## Usage

```ruby
require 'movida_events'

client = MovidaEvents::Client.new(username: 'my_user', password: 'my_pass')
poller = MovidaEvents::Poller.new(client)
poller.poll do |event|
  puts event.inspect
end
```

Above, we first create a `Client` object. This serves as the interface between
the poller and Movida. We then create a `Poller` object with that client. Then
using the `poll` method, we print each event.

By default, the Poller only processes events that occur after the poller has
started.

### Starting at after a given event

Usually, you want to keep track of which event was processed last, so that you
can ensure that every event gets processed. Use the `newer_than` option to tell
the poller to process all events after a given ID.

```ruby
MovidaEvents::Poller.new(client, newer_than: 1234).poll do |event|
  # All events after (but not including) event 1234 will be processed here
end
```

### Filtering event types

You can limit the types of events by setting the `event_types` option.

```ruby
types = ['title_created', 'title_updated']
MovidaEvents::Poller.new(client, event_types: types).poll do |event|
  # Only title_created and title_updated events will be processed here
end
```

The `event_types` option also accepts a comma separated string like
`"title_created,title_updated"`.

### The poll interval

The poller checks for new events every few seconds. The default poll interval is
30 seconds, that can be changed with the `interval` option.

Note that even though the poller checks for new events every few seconds, the
processing block will not get called unless there is a new event.

```ruby
# Polls every 5 seconds to check for new events
MovidaEvents::Poller.new(client, interval: 5)
```

### Run code for every poll

The processing block only gets called if an event is found, but we can use the
`on_poll` method to set a callback for every time the poller checks for new
events. This is especially useful for logging. It could be used to broadcast a
heartbeat, etc.


```ruby
poller.on_poll do |stats|
  log("Polled #{stats.requests} times")
end
poller.poll
```

See below for more information about the `stats` object.

### Stats

The blocks for `poll` and `on_poll` both accept a stats object. It contains
information about the current poller status. The available methods are:

- last: The ID of the event processed last. In the case of the `poll` method,
  this is the current event ID.
- requests: The number of requests processed including the current one.
- events: The number of events processed including the current one.
- request\_events: The number of events processed in the current request
  including the current one. For `on_poll` this will always be 0.

```ruby
poller.poll do |event, stats|
  log("Processing event number #{stats.events}")
end
```

### Setting the number of times to poll

The `poll` method accepts an argument `times` that sets how many times it checks
for new events. This can be useful for testing.

```ruby
# Will only check for new events once
MovidaEvents::Poller.new(client).poll(1) do |event|
end
```

### Setting the API domain

The default API domain is `movida.bebanjo.net`. It can be set to a different
domain with the `domain` option in the client object.

```ruby
MovidaEvents::Client.new(
  username: 'my_user',
  password: 'my_pass',
  domain: 'staging-movida.bebanjo.net'
)
```

## Development

You can run `bin/console` for an interactive prompt that will allow you to
experiment.

Before committing, run `bin/rake` to run the linter and tests.
