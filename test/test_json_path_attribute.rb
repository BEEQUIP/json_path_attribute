# frozen_string_literal: true

require "test_helper"

describe JsonPathAttribute do
  describe ".parse" do
    let(:data) do
      <<-JSON
        {
          "data": {
            "content": {
              "title": "How to drive on snow?",
              "body": "Use a low gear and slowly build up the speed."
            },
            "user": {
              "name": "James May",
              "email": "jamesmay@example.com"
            },
            "comments": [
              {
                "content": {
                  "body": "Thank you for the tip! It is very useful."
                },
                "likes": 5,
                "user": {
                  "name": "Charles Careful",
                  "email": "charlescareful@example.com"
                }
              },
              {
                "content": {
                  "body": "I should have known this earlier. Just crashed my car!"
                },
                "likes": 15,
                "user": {
                  "name": "Freddy Fast",
                  "email": "freddyfast@example.com"
                }
              }
            ]
          }
        }
      JSON
    end

    let(:post) { Post.parse(data) }

    it "parses the JSON and assigns the attributes based on their paths" do
      # Post
      assert_equal "How to drive on snow?", post.title
      assert_equal "Use a low gear and slowly build up the speed.", post.body

      # Author
      assert_equal "James May", post.author.name
      assert_equal "jamesmay@example.com", post.author.email

      # Comments
      assert_equal 2, post.comments.size
      assert_equal "Thank you for the tip! It is very useful.", post.comments[0].body
      assert_equal "Charles Careful", post.comments[0].commenter.name
    end

    describe "when the JSON does not contain all attributes" do
      let(:data) do
        <<-JSON
          {
            "data": {
              "content": {
                "title": "How to drive on snow?"
              },
              "user": {
                "name": "James May",
                "email": null
              }
            }
          }
        JSON
      end

      it "parses the JSON and (partially) assigns attributes based on their path" do
        # Post
        assert_equal "How to drive on snow?", post.title
        assert_nil post.body

        # Author
        assert_equal "James May", post.author.name
        assert_nil post.author.email

        # Comments
        assert_equal 0, post.comments.size
        assert_empty post.comments
      end
    end

    describe "when the input is a Hash" do
      let(:data) do
        {
          data: {
            content: {
              title: "How to drive on ice?",
              body: "Full throttle and just drift."
            },
            comments: [
              {
                content: {
                  body: "Thank you for the tip! I am very excited!"
                },
                likes: 5,
                user: {
                  name: "Erik Exciting",
                  email: "erikexciting@example.com"
                }
              },
              {
                content: {
                  body: "I cannot do this, it goes against my nature"
                },
                likes: 15,
                user: {
                  name: "Sully Slow",
                  email: "sullyslow@example.com"
                }
              }
            ]
          }
        }
      end

      it "parses the hash and assigns the attributes based on the path" do
        # Post
        assert_equal "How to drive on ice?", post.title
        assert_equal "Full throttle and just drift.", post.body

        # Comments
        assert_equal 2, post.comments.size
        assert_equal "Thank you for the tip! I am very excited!", post.comments[0].body
        assert_equal "Erik Exciting", post.comments[0].commenter.name
      end
    end
  end

  describe ".parse_collection" do
    let(:data) do
      <<-JSON
           [
             {
               "content": {
                 "body": "Thank you for the tip! It is very useful."
               },
               "likes": 5,
               "user": {
                 "name": "Charles Careful",
                 "email": "charlescareful@example.com"
               }
             },
             {
               "content": {
                 "body": "I should have known this earlier. Just crashed my car!"
               },
               "likes": 15,
               "user": {
                 "name": "Freddy Fast",
                 "email": "freddyfast@example.com"
               }
             }
           ]
      JSON
    end

    let(:comments) { Comment.parse_collection(data) }

    it "parses" do
      assert_equal 2, comments.count
      assert_equal [Comment, Comment], comments.map(&:class)

      assert_equal "Thank you for the tip! It is very useful.", comments[0].body
      assert_equal "Charles Careful", comments[0].commenter.name
    end

    describe "when the data is a Hash" do
      let(:data) do
        [
          {
            content: {
              body: "Thank you for the tip! I am very excited!"
            },
            likes: 5,
            user: {
              name: "Erik Exciting",
              email: "erikexciting@example.com"
            }
          },
          {
            content: {
              body: "I cannot do this, it goes against my nature"
            },
            likes: 15,
            user: {
              name: "Sully Slow",
              email: "sullyslow@example.com"
            }
          }
        ]
      end

      it "parses" do
        assert_equal 2, comments.size
        assert_equal "Thank you for the tip! I am very excited!", comments[0].body
        assert_equal "Erik Exciting", comments[0].commenter.name
      end
    end
  end

  describe ".parse_first" do
    let(:data) do
      <<-JSON
           [
             {
               "content": {
                 "body": "Thank you for the tip! It is very useful."
               },
               "likes": 5,
               "user": {
                 "name": "Charles Careful",
                 "email": "charlescareful@example.com"
               }
             },
             {
               "content": {
                 "body": "I should have known this earlier. Just crashed my car!"
               },
               "likes": 15,
               "user": {
                 "name": "Freddy Fast",
                 "email": "freddyfast@example.com"
               }
             }
           ]
      JSON
    end

    let(:comment) { Comment.parse_first(data) }

    it "parses only the first comment" do
      assert comment
      assert_equal "Thank you for the tip! It is very useful.", comment.body
      assert_equal "Charles Careful", comment.commenter.name
    end
  end
end
