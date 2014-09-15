require 'docker_registry'

class DockerRegistry::Tag
  attr_reader :name, :image_id, :repository

  def initialize(name, image_id, repository)
    @name = name
    @image_id = image_id
    @repository = repository
  end

  def registry
    @repository.registry
  end

  def delete!
    registry.delete_reporitory_tag(self)
  end

  def inspect
    "#<DockerRegistry::Tag #{@repository.full_name}:#{name} >"
  end
end

