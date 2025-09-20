# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "json_path_attribute"

require "minitest/autorun"

User = Class.new do
  include JsonPathAttribute

  json_path_attribute :name, type: :string, path: "name"
  json_path_attribute :email, type: :string, path: "email"
end

Comment = Class.new do
  include JsonPathAttribute

  json_path_attribute :body, type: :string, path: "content.body"
  json_path_attribute :likes, type: :integer, path: "likes"
  json_path_attribute :commenter, type: User, path: "user"
end

Post = Class.new do
  include JsonPathAttribute

  json_path_attribute :title, type: :string, path: "data.content.title"
  json_path_attribute :body, type: :string, path: "data.content.body"
  json_path_attribute :author, type: User, path: "data.user"
  json_path_attribute :comments, type: Comment, array: true, path: "data.comments"
end
