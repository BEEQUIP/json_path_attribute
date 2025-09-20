# frozen_string_literal: true

module JsonPathAttribute
  AttributeDefinition = Data.define(:type, :path_string, :array) do
    def array? = !!array
    def path = path_string.include?(" ") ? "'#{path_string}'" : path_string
    def full_path = "$.#{path}"

    def value(parsed)
      value = JsonPath.on(parsed, full_path)
      value = value.first unless full_path.include?("[*]") && value.present?
      value = [] if value.nil? && array?
      value
    end
  end
end
