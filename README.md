# JSON Builder
Rails provides an excellent XML Builder by default to build RSS and ATOM feeds, but nothing to help you build complex and custom JSON data structures. The standard `to_json` works well, but can get very verbose when you need full control of what is generated. JSON Builder hopes to solve that problem.

## Speed
JSON Builder is very fast, it's roughly 6 times faster than the core XML Builder.

                            user       system     total     real
    JSON Builder            0.700000   0.030000   0.730000  (0.724748)
    JSON Builder Pretty     1.080000   0.060000   1.140000  (1.149416)
    XML Builder             4.700000   0.110000   4.810000  (4.822932)

## Using JSON Builder with Rails
First, make sure to add `json_builder` to your `Gemfile`.

    gem 'json_builder'

Not required, but if you'd like to run the generated JSON through a prettifier for debugging reasons, just edit it in your environment config. It defaults to false for speed improvements.

    Your::Application.configure do
      config.action_view.pretty_print_json = true
    end

Second, make sure your controller responds to `json`:

    class PostsController < ApplicationController
      respond_to :json
      
      def index
        @posts = Post.all
        respond_with @posts
      end
    end

Lastly, create `app/views/posts/index.json.builder` which could look something like:

    json.array! @posts do
      @posts.each do |user|
        json.array_item! do
          render :partial => 'post', :locals => { :json => json, :post => post }
        end
      end
    end

You will get something like:

    [{
      "id": 1,
      "name": "Garrett Bjerkhoel"
    }, {
      "id": 2,
      "name": "John Doe"
    }]

## Sample Usage

    require 'json_builder'
    json = JSONBuilder::Generator.new

    json.name "Garrett Bjerkhoel"
    json.address do
      json.street "1143 1st Ave"
      json.street2 "Apt 1"
      json.city "New York"
      json.state "NY"
      json.zip 10065
    end
    json.skills do
      json.ruby true
      json.asp false
    end
    
    puts json.compile!

## Examples
See the [examples](http://github.com/dewski/json_builder/tree/master/examples) directory.

## Copyright
Copyright © 2010 Garrett Bjerkhoel. See [MIT-LICENSE](http://github.com/dewski/json_builder/blob/master/MIT-LICENSE) for details.