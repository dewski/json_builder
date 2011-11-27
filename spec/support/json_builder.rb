module JSONBuilder
  module RSpecHelpers
    def json_builder(*args, &block)
      JSONBuilder::Compiler.generate(*args, &block)
    end
  end
end