module JSONBuilder
  class Elements
    attr_accessor :compilers
    
    def initialize(scope, items, &block)
      raise InvalidArgument.new('items does not respond to each') unless items.respond_to?(:each)
      
      @compilers = []
      
      items.each do |item|
        @compilers << Value.new(scope, item, &block)
      end
    end
    
    def to_s
      "[#{@compilers.collect(&:to_s).join(', ')}]"
    end
  end
end
