require 'uri'
require 'docker_registry'
require 'docker_registry/client'
require 'docker_registry/repository'
require 'docker_registry/tag'

class DockerRegistry::Registry
  attr_reader :url, :options, :client

  # @see DockerRegistry::Client#initialize
  def initialize(url)
    @url = url
    @uri = URI.parse(url)
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

  def repositry_tags(repository)
    (@client.repositry_tags(repository.name) || {}).map do |name, image_id|
      DockerRegistry::Tag.new(name, image_id, repository)
    end
  end

  def delete_repository(repository)
    @client.delete_repository(repository.name)
  end

  def delete_reporitory_tag(tag)
    @client.delete_reporitory_tag(tag.repository.name, tag.name)
  end
end
