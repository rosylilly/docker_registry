require 'faraday_middleware/response_middleware'
require 'docker_registry'

module DockerRegistry
  class OjParser < FaradayMiddleware::ResponseMiddleware
    dependency do
      require 'oj' unless defined?(::Oj)
    end

    define_parser do |body|
      ::Oj.load(body) unless body.strip.empty?
    end
  end
end
