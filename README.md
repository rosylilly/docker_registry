# DockerRegistry

Docker registry HTTP API client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'docker_registry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docker_registry

## Usage

```ruby
registry = DockerRegistry::Registry.new("https://index.docker.io")
registry.search("dockerfile/ruby")
# =>
#     [
#       #<DockerRegistry::Repository ... >,
#       #<DockerRegistry::Repository ... >,
#       #<DockerRegistry::Repository ... >
#       ...
#     ]

repository = client.all[0]
repository.tags
# =>
#     [
#       #<DockerRegistry::Tag ... >,
#       #<DockerRegistry::Tag ... >,
#       #<DockerRegistry::Tag ... >
#       ...
#     ]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/docker_registry/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
