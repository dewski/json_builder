# JSON Builder
Rails provides an excellent XML Builder by default to build RSS and ATOM feeds, but nothing to help you build complex and custom JSON data structures. The standard `to_json` works well, but can get very verbose when you need full control of what is generated. JSON Builder hopes to solve that problem.

## Using JSON Builder with Rails
First, make sure to add the gem to your `Gemfile`.

    gem 'json_builder'

Second, make sure your controller responds to `json`:

    class PostsController < ApplicationController
      respond_to :json
      
      def index
        @posts = Post.all
        respond_with @posts
      end
    end

Lastly, create `app/views/posts/index.json_builder` which could look something like:
    
    posts @posts do |post|
      id post.id
      name post.name
      body post.body
    end

You will get something like:

    {
      "posts": [
        {
          "id": 1,
          "name": "Garrett Bjerkhoel",
          "body": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod."
        }, {
          "id": 2,
          "name": "John Doe",
          "body": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod."
        }
      ]
    }

## Sample Usage

    require 'json_builder'
    json = JSONBuilder::Compiler.generate {
      name "Garrett Bjerkhoel"
      address do
        street "1143 1st Ave"
        street2 "Apt 1"
        city "New York"
        state "NY"
        zip 10065
      end
      skills do
        ruby true
        asp false
      end
    }

## Conversions

Time - [ISO-8601](http://en.wikipedia.org/wiki/ISO_8601)

## Speed
JSON Builder is very fast, it's roughly 3.6 times faster than the core XML Builder based on the [speed benchmark](http://github.com/dewski/json_builder/blob/master/spec/benchmarks/builder.rb).


                 user       system      total       real
    JSONBuilder  2.950000   0.010000    2.960000    (2.968790)
        Builder  10.820000  0.040000    10.860000   (10.930497)

## Examples
See the [examples](http://github.com/dewski/json_builder/tree/master/examples) directory.

## Copyright
Copyright © 2011 Garrett Bjerkhoel. See [MIT-LICENSE](http://github.com/dewski/json_builder/blob/master/MIT-LICENSE) for details.