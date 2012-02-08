module JSONBuilder
  class Elements
    attr_accessor :compilers

    # Public: Creates a new instance of the Elements that generates
    # an array of JSONBuilder::Member objects.
    #
    # scope - The view scope context for any variables.
    # items - The array of elements to create values from.
    # block - Yielding any block passed to the element.
    #
    # Raises InvalidArgument if the items passed does not respond to each.
    # Returns a new instance of Elements.
    def initialize(scope, items, &block)
      raise InvalidArgument.new('items does not respond to each') unless items.respond_to?(:each)

      @compilers = []

      items.each do |item|
        @compilers << Value.new(scope, item, &block)
      end
    end

    # Public: Generates the array JSON block local values
    #
    # Returns a formated JSON String
    def to_s
      "[#{@compilers.collect(&:to_s).join(', ')}]"
    end
  end
end
