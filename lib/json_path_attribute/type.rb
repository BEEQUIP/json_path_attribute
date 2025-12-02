# frozen_string_literal: true

require "active_model"

module JsonPathAttribute
  # Provides a way to cast values to a specific type
  # This class is intended to be used internally by JsonPathAttribute
  class Type
    class << self
      def cast_attribute(type, value, array: false)
        return value if type == :source
        return cast_object_attribute(type, value, array: array) if type.is_a?(Class)

        cast_to(type, value, array: array)
      end

      def cast_to(type, value, array: false)
        return [] if value.nil? && array
        return false if value.nil? && type == :boolean

        cast_type = ActiveModel::Type.lookup(type)

        if array
          cast_array(value, type, cast_type)
        else
          cast_value(value, type, cast_type)
        end
      end

      def cast_array(values, type, cast_type)
        values.map do |value|
          next false if value.nil? && type == :boolean

          cast_type.cast(value)
        end
      end

      def cast_value(value, type, cast_type)
        value = value.to_s if type == :decimal && value.is_a?(Float)

        cast_type.cast(value)
      end

      def cast_object_attribute(type, value, array:)
        raise ArgumentError, "Unable to cast #{value.inspect} to #{type} object" if value.nil?

        if array
          value.map { |element| type.parse(element) }
        else
          type.parse(value)
        end
      end
    end
  end
end
