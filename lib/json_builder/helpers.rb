module JSONBuilder
  module Helpers
    # Private: Takes all instance variables from the scope passed to it
    # and makes them available to the block that gets compiled.
    #
    # object  - The scope which contains the instance variables.
    # exclude - Any instance variables that should not be set.
    #
    # Returns nothing.
    def copy_instance_variables_from(object, exclude = []) #:nodoc:
      vars = object.instance_variables.map(&:to_s) - exclude.map(&:to_s)
      vars.each { |name| instance_variable_set(name.to_sym, object.instance_variable_get(name)) }
    end
  end
end