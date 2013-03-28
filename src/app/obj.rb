require 'uuid'

class Obj

  @@objects = {}

  attr_accessor :uuid

  def initialize(options = {})
    options.each_pair do |key, value|
      instance_variable_set "@#{key}", value
    end
    self.uuid = UUID.generate
  end


  def to_json

    result = {}
    instance_variables.map do |v|
      name = v.to_s.gsub(/@/, '').to_sym
      result[name] = instance_variable_get v
    end

    result.to_json
  end


  def save
    self.class.add_object self
  end

  def self.add_object obj
    @@objects[obj.uuid] = obj
  end

  def self.find uuid
    @@objects[uuid]
  end

  def self.all
    @@objects
  end


end