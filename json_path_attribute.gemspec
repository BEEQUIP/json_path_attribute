# frozen_string_literal: true

require_relative "lib/json_path_attribute/version"

Gem::Specification.new do |spec|
  spec.name = "json_path_attribute"
  spec.version = JsonPathAttribute::VERSION
  spec.authors = ["Daniël de Vries", "Jan van der Pas", "Marthyn Olthof"]
  spec.email = %w[daniel.devries@beequip.nl jan.vanderpas@beequip.nl marthyn.olthof@beequip.nl]

  spec.summary = "An object mapper for mapping JSON data to a Ruby object"
  spec.description = "JsonPathAttribute is an object mapper to create Ruby objects from JSON"
  spec.homepage = "https://github.com/BEEQUIP/json_path_attribute"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  # spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 7.2"
  spec.add_dependency "jsonpath", "~> 1.1"
end
