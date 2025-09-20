# JsonPathAttribute

JsonPathAttribute is a simple but powerful object mapper to map JSON or Hash data into Ruby objects, using [JsonPath](https://github.com/joshbuddy/jsonpath).

Although this gem has been released fairly recently, it was originally developed for [Beequip](http://beequip.com) and a very similar version has been used for a few years.

## Usage

Given a JSON (or Ruby hash) like this:

```json
{
  "post": {
    "title": "How to drive on snow?",
    "body": "Just use a low gear and slowly build up speed",
    "likes": 12,
    "comments": [
      {
        "body": "Thank you for the tip! It is very useful.",
        "user": {
          "name": "Charles Careful"
        }
      }
    ]
  }
}
```

You can include `JsonPathAttribute` to a Ruby class:

```ruby
class Post
  include JsonPathAttribute

  json_path_attribute :title, path: 'post.title'
  json_path_attribute :likes, path: 'post.likes', type: :integer
  json_path_attribute :comments, path: 'post.comments[*]', type: Comment, array: true
end

class Comment
  include JsonPathAttribute

  json_path_attribute :body, path: 'body'
  json_path_attribute :name, path: 'user.name'
end
```

And it gets parsed like this

```ruby
post = Post.parse(json) # => <Post:...>
post.title # => "How to drive on snow?"
post.body # => "Just use a low gear and slowly build up speed"
post.likes # => 12
post.comments # => [#<Comment:0x000000011e4354d0 @body="Thank you for the tip! It is very useful.", @name="Charles Careful">]
```

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add json_path_attribute
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install json_path_attribute
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BEEQUIP/json_path_attribute.

## Acknowledgements

Thanks to the original authors [jdongelmans](https://github.com/jdongelmans) and [jandintel](https://github.com/jandintel).

Also thanks to [joshbuddy](https://github.com/joshbuddy) for creating [JsonPath](https://github.com/joshbuddy/jsonpath).
