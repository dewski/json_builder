# JSON Builder
Rails provides an excellent XML Builder by default to build RSS and ATOM feeds, but nothing to help you build complex and custom JSON data structures. The standard `to_json` works just fine, but can get very verbose when you need full control of what is generated and performance is a factor. JSON Builder hopes to solve that problem.

## Sample Usage

```ruby
require 'json_builder'

json = JSONBuilder::Compiler.generate do
  name "Garrett Bjerkhoel"
  email "spam@garrettbjerkhoel.com"
  address do
    street "1234 1st Ave"
    street2 "Apt 1"
    city "New York"
    state "NY"
    zip 10065
  end
  skills do
    ruby true
    asp false
  end
  hash do
    # Could be a highly intensive process that only returns a string
    "12345" * 25
  end
end
```

Which will generate:

```json
{
  "name": "Garrett Bjerkhoel",
  "email": "spam@garrettbjerkhoel.com",
  "address": {
    "street": "1234 1st Ave",
    "street2": "Apt 1",
    "city": "New York",
    "state": "NY",
    "zip": 10065
  },
  "skills": {
    "ruby": true,
    "asp": false
  },
  "hash": "1234512345123451234512345..."
}
```

If you'd like to just generate an array, you can do the following:

```ruby
array ["Garrett Bjerkhoel", "John Doe"] do |name|
  first, last = name.split(' ')
  first first
  last last
end
```

Which will generate:

```json
[
  {
    "first": "Garrett",
    "last": "Bjerkhoel"
  },
  {
    "first": "John",
    "last": "Doe"
  }
]
```

Just a note, if you use an array block, all other builders will be ignored outside of that block.

## Using JSON Builder with Rails
First, make sure to add the gem to your `Gemfile`.

```ruby
gem 'json_builder'
```

Second, make sure your controller responds to `json`:

```ruby
class UsersController < ApplicationController
  respond_to :json
  
  def index
    @users = User.order('id DESC').page(params[:page]).per(2)
    respond_with @users
  end
end
```

Lastly, create `app/views/users/index.json_builder` which could look something like:
    
```ruby
count @users.count
current_page @users.current_page
per_page @users.per_page
num_pages @users.num_pages
results @users do |user|
  id user.id
  name user.name
  body user.body
  links user.links do |link|
    url link.url
    visits link.visits
    last_visited link.last_visited
  end
end
```

You will get something like:

```json
{
  "total": 10,
  "page": 1,
  "per_page": 2,
  "total_pages": 5,
  "results": [
    {
      "id": 1,
      "name": "Garrett Bjerkhoel",
      "body": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.",
      "links": [
        {
          "url": "http://github.com/",
          "visits": 500,
          "last_visited": "2011-11-271T00:00:01Z"
        },
        {
          "url": "http://garrettbjerkhoel.com/",
          "visits": 1500,
          "last_visited": "2011-11-261T00:00:01Z"
        }
      ]
    }, {
      "id": 2,
      "name": "John Doe",
      "body": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.",
      "links": [
        {
          "url": "http://google.com/",
          "visits": 11000,
          "last_visited": "2010-05-221T00:00:01Z"
        },
        {
          "url": "http://twitter.com/",
          "visits": 155012857,
          "last_visited": "2011-11-261T00:00:01Z"
        }
      ]
    }
  ]
}
```

## Conversions

Time - [ISO-8601](http://en.wikipedia.org/wiki/ISO_8601)

## Speed
JSON Builder is very fast, it's roughly 3.6 times faster than the core XML Builder based on the [speed benchmark](http://github.com/dewski/json_builder/blob/master/spec/benchmarks/builder.rb).

                 user       system      total       real
    JSONBuilder  2.950000   0.010000    2.960000    (2.968790)
        Builder  10.820000  0.040000    10.860000   (10.930497)

## Examples
See the [examples](http://github.com/dewski/json_builder/tree/master/examples) directory.

## Note on Patches/Pull Requests

- Fork the project.
- Make your feature addition or bug fix.
- Add tests for it. This is important so I don't break it in a future version unintentionally.
- Commit, do not mess with Rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself in another branch so I can ignore when I pull)
- Send me a pull request. Bonus points for topic branches.

## Copyright
Copyright © 2011 Garrett Bjerkhoel. See [MIT-LICENSE](http://github.com/dewski/json_builder/blob/master/MIT-LICENSE) for details.