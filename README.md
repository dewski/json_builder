# JSON Builder

You have the option to run your JSON through a prettifier before it's returned.

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