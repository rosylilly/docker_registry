require 'uri'
require 'docker_registry'
require 'docker_registry/client'
require 'docker_registry/repository'
require 'docker_registry/tag'

class DockerRegistry::Registry
  attr_reader :base_uri, :options, :client

  # @see DockerRegistry::Client#initialize
  def initialize(uri)
    @uri = URI.parse(uri)
    @client = DockerRegistry::Client.new(
      "#{@uri.scheme}://#{@uri.host}:#{@uri.port}",
      user: @uri.user,
      password: @uri.password
    )
  end

  def domain
    @domain ||= @uri.host
  end

  def ping
    @client.ping
  end

  def all
    search
  end

  def search(query = '')
    (@client.search(query)['results'] || []).map do |repo|
      DockerRegistry::Repository.new(repo, self)
    end
  end

  def [](name)
    DockerRegistry::Repository.new({ name: name }, self)
  end

  def repositry_tags(repository)
    (@client.repositry_tags(repository.name) || {}).map do |name, image_id|
      DockerRegistry::Tag.new(name, image_id, repository)
    end
  end

  def repositry_tag(repository, tag)
    image_id = (@client.repositry_tag(repository.name, tag) || "")
    DockerRegistry::Tag.new(tag, image_id, repository)
  end

  def delete_repository(repository)
    @client.delete_repository(repository.name)
  end

  def delete_reporitory_tag(tag)
    @client.delete_reporitory_tag(tag.repository.name, tag.name)
  end
end
