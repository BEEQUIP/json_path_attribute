# frozen_string_literal: true

module JsonPathAttribute
  # Provides a way to cast values to a specific type
  # This class is intended to be used internally by JsonPathAttribute
  class Type
    class << self
      def cast_attribute(type, value, array: false)
        return value if type == :source

        if value.nil?
          return [] if array
          return false if type == :boolean
        end

        array ? cast_array(type, value) : cast_value(type, value, array)
      end

      def cast_value(type, value, array)
        return cast_object_attribute(type, value, array: array) if type.is_a?(Class)
        return false if type == :boolean && value.nil?

        case type
        when :string, :decimal
          value.to_s
        when :integer
          value.to_i
        else
          raise TypeError, "Unable to cast #{value.inspect} to #{type}"
        end
      end

      def cast_array(type, values)
        values.map { |element| cast_value(type, element, false) }
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
