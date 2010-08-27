# JSON Builder
Rails provides an excellent XML Builder by default to build RSS and ATOM feeds, but nothing to help you build JSON. The standard `to_json` works well, but can get very verbose when you need full control of what the user gets, this is where JSON Builder comes in.

## Using JSON Builder With Rails
Make sure to add `json_builder` to your `Gemfile`.

    gem 'json_builder'

You then have the option to run your JSON through a prettifier before it's returned.

    JSON::Application.configure do
      config.action_view.pretty_print_true = false
    end

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
    
    puts json.compile

## Examples
See the examples directory.
http://github.com/dewski/json_builder/tree/master/examples

## Copyright
Copyright © 2010 Garrett Bjerkhoel. See MIT-LICENSE for details.