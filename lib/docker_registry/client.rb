require 'faraday'
require 'faraday_middleware'
require 'docker_registry'
require 'docker_registry/oj_parser'

class DockerRegistry::Client
  # @param [#to_s] base_uri Docker registry base URI
  # @param [Hash] options Client options
  # @option options [#to_s] :user User name for basic authentication
  # @option options [#to_s] :password Password for basic authentication
  def initialize(base_uri, options = {})
    @base_uri = base_uri.to_s
    @faraday = Faraday.new(@base_uri) do |builder|
      builder.request :json
      builder.use DockerRegistry::OjParser, content_type: /\bjson$/

      if options[:user] && options[:password]
        builder.request(
          :basic_auth,
          options[:user].to_s, options[:password].to_s
        )
      end

      builder.adapter :net_http
    end
  end

  def ping
    @faraday.get('/v1/_ping').body === true
  end

  # @param [#to_s] query Seach query
  def search(query = '')
    @faraday.get('/v1/search', { q: query }).body
  end

  def repositry_tags(name)
    @faraday.get("/v1/repositories/#{name}/tags").body
  end

  def delete_repository(name)
    @faraday.delete("/v1/repositories/#{name}/").status == 200
  end

  def delete_reporitory_tag(repository_name, tag_name)
    @faraday\
      .delete("/v1/repositories/#{repository_name}/tags/#{tag_name}")\
      .status == 200
  end
end
