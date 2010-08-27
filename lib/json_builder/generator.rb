require 'rubygems'
require 'blankslate' unless defined?(BlankSlate)
require 'json'

module JSONBuilder
  class Generator < BlankSlate
    def initialize(options=nil)
      @pretty_print ||= options.delete(:pretty) if !options.nil? && options[:pretty] # don't want nil
      @compiled = []
      @indent = 0
      @passed_items = 0
      @indent_next = false
      @is_array = false
    end

    def inspect
      finished
    end

    def tag!(sym, *args, &block)
      method_missing(sym.to_sym, *args, &block)
    end

    def array!(set, &block)
      @array_length = set.length if set.is_a?(Array)
      @is_array = true
      method_missing(nil, nil, &block)
    end

    def array_item!(&block)
      method_missing(nil, nil, &block)

      @passed_items += 1
      @compiled << '},{' if @passed_items < @array_length
    end

    def method_missing(sym, *args, &block)
      text = type_cast(args.first)

      if block
        start_block(sym) unless sym.nil?
        block.call(self)
        end_block unless sym.nil?
      else
        if @indent_next
          @compiled[@compiled.length-1] = @compiled.last + "\"#{sym}\":#{text}"
          @indent_next = false
        else
          @compiled << "\"#{sym}\":#{text}"
        end
      end
    end

    def finished
      if @is_array
        compiled = ('[{' + @compiled.join(',') + '}]').gsub(',},{,', '},{')
      else
        compiled = '{' + @compiled.join(',') + '}'
      end

      if @pretty_print
        JSON.pretty_generate(JSON[compiled])
      else
        compiled
      end
    end

    # Since most methods here are public facing,
    private
      def type_cast(text)
        case text
          when Array then '['+ text.map! { |j| type_cast(j) }.join(',') +']'
          when Hash then 'teheh'
          when String then "\"#{text}\""
          when TrueClass then 'true'
          when FalseClass then 'false'
          when NilClass then 'null'
          when DateTime, Time, Date then "\"#{text.strftime("%Y-%m-%dT%H:%M:%S")}\""
          when Fixnum then text
        end
      end

      def start_indent
        @indent += 1
      end

      def end_indent
        @indent -= 1
      end

      def start_block(sym)
        start_indent
        @indent_next = true
        @compiled << "\"#{sym}\":{"
      end

      def end_block
        if @indent > 0
          @compiled[@compiled.length-1] = @compiled.last + '}'
        else
          @compiled << '}'
        end
      end
    end
end
