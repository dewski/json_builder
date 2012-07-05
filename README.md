JSON Builder [![Build Status](https://secure.travis-ci.org/dewski/json_builder.png)](http://travis-ci.org/dewski/json_builder)
============
Rails provides an excellent XML Builder by default to build RSS and ATOM feeds, but nothing to help you build complex and custom JSON data structures. The standard `to_json` works just fine, but can get very verbose when you need full control of what is generated and performance is a factor. JSON Builder hopes to solve that problem.

## Sample Usage

```ruby
require 'json_builder'

json = JSONBuilder::Compiler.generate do
  name 'Garrett Bjerkhoel'
  email 'spam@garrettbjerkhoel.com'
  url user_url(user)
  address do
    street '1234 1st Ave'
    city 'New York'
    state 'NY'
    zip 10065
  end
  key :nil, 'testing a custom key name'
  skills do
    ruby true
    asp false
  end
  longstring do
    # Could be a highly intensive process that only returns a string
    '12345' * 25
  end
end
```

Which will generate:

```json
{
  "name": "Garrett Bjerkhoel",
  "email": "spam@garrettbjerkhoel.com",
  "url": "http://examplesite.com/dewski",
  "address": {
    "street": "1234 1st Ave",
    "city": "New York",
    "state": "NY",
    "zip": 10065
  },
  "nil": "testing a custom key name",
  "skills": {
    "ruby": true,
    "asp": false
  },
  "longstring": "1234512345123451234512345..."
}
```

If you'd like to just generate an array:

```ruby
array ['Garrett Bjerkhoel', 'John Doe'] do |name|
  first, last = name.split(' ')
  first first
  last last
end
```

Which will output the following:

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

Just a note, if you use an array block, all other builder methods will be ignored.

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

Lastly, create `app/views/users/index.json.json_builder` which could look something like:
    
```ruby
count @users.count
page @users.current_page
per_page @users.per_page
pages_count @users.num_pages
results @users do |user|
  id user.id
  name user.name
  body user.body
  url user_url(user)
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
  "count": 10,
  "page": 1,
  "per_page": 2,
  "pages_count": 5,
  "results": [
    {
      "id": 1,
      "name": "Garrett Bjerkhoel",
      "body": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.",
      "url": "http://example.com/users/garrett-bjerkhoel",
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
      "url": "http://example.com/users/john-doe",
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

### Rendering Partials

Rendering partials is just as easy as defining your schema. Just pass in any object that responds to `to_partial_path` (such as ActiveRecord models), or a direct path to a partial to render it.

```ruby
count @users.count
partial @users, :as => :users
```

With your partial living at `app/views/users/_user.json_builder`

```ruby
name user.name
awesome user.awesome?
```

The JSON response would be:

```json
{
  "count": 1,
  "users": [
    {
      "name": "Garrett Bjerkhoel",
      "awesome": true
    }
  ]
}
```

### Including JSONP callbacks

Out of the box JSON Builder supports JSONP callbacks when used within a Rails project just by using the `callback` parameter. For instance, if you requested `/users.json?callback=myjscallback`, you'll get a callback wrapping the response:

```json
myjscallback([
  {
    "name": "Garrett Bjerkhoel"
  },
  {
    "name": "John Doe"
  }
])
```

To turn off JSONP callbacks globally or just per-environment:


#### Globally

```ruby
ActionView::Base.json_callback = false
```

#### Per Environment

```ruby
Sample::Application.configure do
  config.action_view.json_callback = false
end
```

### Pretty Print Output

Out of the box JSON Builder supports pretty printing only during development, it's disabled by default in other environments for performance. If you'd like to enable or disable pretty printing you can do it within your environment file or you can do it globally.

With pretty print on:

```json
{
  "name": "Garrett Bjerkhoel",
  "email": "spam@garrettbjerkhoel.com"
}
```

Without:

```json
{"name": "Garrett Bjerkhoel", "email": "spam@garrettbjerkhoel.com"}
```

#### Per Environment

```ruby
Sample::Application.configure do
  config.action_view.pretty_print_json = false
end
```

#### Globally

```ruby
ActionView::Base.pretty_print_json = false
```

## Speed
JSON Builder is very fast, it's roughly 3.6 times faster than the core XML Builder based on the [speed benchmark](http://github.com/dewski/json_builder/blob/master/spec/benchmarks/builder.rb).

                 user       system      total       real
    JSONBuilder  2.950000   0.010000    2.960000    (2.968790)
        Builder  10.820000  0.040000    10.860000   (10.930497)

## Alternative libraries

There are alternatives to JSON Builder, each good in their own way with different API's and design approaches that are worth checking out. Although, I would love to hear why JSON Builder didn't fit your needs, by [message or issue.

 * [jbuilder](https://github.com/rails/jbuilder)
 * [RABL](https://github.com/nesquena/rabl)
 * [Tequila](https://github.com/inem/tequila)
 * [Argonaut](https://github.com/jbr/argonaut)
 * [Jsonify](https://github.com/bsiggelkow/jsonify)
 * [RepresentationView](https://github.com/mdub/representative_view)

## Note on Patches/Pull Requests

- Fork the project.
- Make your feature addition or bug fix.
- Add tests for it. This is important so I don't break it in a future version unintentionally.
- Commit, do not mess with Rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself in another branch so I can ignore when I pull)
- Send me a pull request. Bonus points for topic branches.

## Copyright
Copyright © 2012 Garrett Bjerkhoel. See [MIT-LICENSE](http://github.com/dewski/json_builder/blob/master/MIT-LICENSE) for details.