require 'rubygems'
require 'blankslate' unless defined? BlankSlate
require 'active_support'
require 'json'

module JSONBuilder
  class Generator < BlankSlate
    def initialize
      @c = {}
      @compiled = []
      @indent = 0
    end
    
    #
    # Using +tag!+ is neccessary when dynamic keys are needed
    # 
    #     json.tag! 
    #
    def tag!(sym, *args, &block)
      method_missing(sym.to_sym, *args, &block)
    end

    def method_missing(sym, *args, &block)
      text = type_cast(args.first)
      puts sym
      puts text
      if block
        # start_block(sym) unless sym.nil?
        block.call(self)
        # end_block unless sym.nil?
      else
        @c[sym] = text
      end
    end

    def compile!(pretty=false)
      compiled = "{#{@c}}"
      
      if pretty
        JSON.pretty_generate(JSON[compiled])
      else
        compiled
      end
    end

    # Since most methods here are public facing,
    private
      def type_cast(text)
        case text
          when Array then '['+ text.map! { |j| type_cast(j) }.join(', ') +']'
          when Hash then loop_hash(text)
          when String then "\"#{text.gsub(/\"/, '\"')}\""
          when TrueClass then 'true'
          when FalseClass then 'false'
          when NilClass then 'null'
          when Time, Date then "\"#{text.strftime('%Y-%m-%dT%H:%M:%S%z')}\""
          when Fixnum, Bignum then text
          else "'#{text.to_s}'"
        end
      # Incase we reach the else, where +to_s+ may not be implemented yet.
      rescue NoMethodError
        "''"
      end
      
      def loop_hash(hash)
        compiled_hash = []
        
        hash.each do |key, value|
          compiled_hash << "\"#{key.to_s}\": #{type_cast(value)}"
        end
        
        '{' + compiled_hash.join(', ') + '}'
      end
    end
end
