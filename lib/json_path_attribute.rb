# frozen_string_literal: true

require "json"
require "jsonpath"
require "active_support/core_ext/hash/keys"

require_relative "json_path_attribute/attribute_definition"
require_relative "json_path_attribute/type"
require_relative "json_path_attribute/version"

# Include this module
#   class Post
#     include JsonPathAttribute
#
#     json_path_attribute:title, path: 'title'
#   end
module JsonPathAttribute
  class Error < StandardError; end
  class TypeCastError < Error; end

  ##
  # This module includes the class methods:
  #   .path_attribute
  #   .path_attribute_definitions
  #   .parse
  #   .parse_collection
  #   .parse_first
  # See the respective methods for documentation
  module ClassMethods
    # This method is used to define an attribute expected at a specific path
    # It also adds an instance variable with reader and setter method with the given name
    # @name [Symbol] Also adds a reader and setter method with the given name
    # @path [String] JSON Path
    # @type [Symbol | Class] (optional) Casts the attribute to the defined type.
    #       This argument can be a symbol, like `:integer` or `:string`, or another class
    #       that includes JsonPathAttribute.
    # @array [Boolean]
    def json_path_attribute(name, path:, type: :source, array: false)
      attribute_definitions[name] = AttributeDefinition.new(type: type, path_string: path, array: array)

      define_method name do
        instance_variable_get("@#{name}")
      end

      define_method "#{name}=" do |value|
        instance_variable_set("@#{name}", Type.cast_attribute(type, value, array: array))
      end
    end

    def attribute_definitions
      @attribute_definitions ||= {}
    end

    def parse(json_or_hash)
      parsed = parse_json_hash_or_array(json_or_hash)

      attributes = attribute_definitions.each_with_object({}) do |(name, definition), hash|
        value = definition.value(parsed)

        next if value.nil?

        hash[name] = value
      end

      new(attributes.merge(response: parsed))
    end

    def parse_collection(json_array_or_array)
      array = parse_json_hash_or_array(json_array_or_array)
      array.map do |item|
        parse(item)
      end
    end

    def parse_first(json_array_or_array)
      array = parse_json_hash_or_array(json_array_or_array)
      parse(array.first)
    end

    private

    def parse_json_hash_or_array(json_hash_or_array)
      json_hash_or_array = json_hash_or_array.deep_stringify_keys if json_hash_or_array.is_a?(Hash)
      json_hash_or_array.is_a?(String) ? JSON.parse(json_hash_or_array) : json_hash_or_array
    end
  end

  attr_accessor :response

  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
