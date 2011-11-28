module JSONBuilder
  class Elements
    attr_accessor :compilers
    
    def initialize(items, &block)
      @compilers = []
      
      items.each do |item|
        @compilers << Value.new(item, &block)
      end
    end
    
    def to_s
      "[#{@compilers.collect(&:to_s).join(', ')}]"
    end
  end
end
