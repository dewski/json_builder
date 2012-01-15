require 'rubygems'
require 'benchmark'
require 'builder'
require 'json_builder'

Benchmark.bm do |b|
  b.report('JSONBuilder') do
    15_000.times {
      JSONBuilder::Compiler.generate {
        name "Garrett Bjerkhoel"
        birthday Time.local(1991, 9, 14)
        street do
          address "1143 1st Ave"
          address2 "Apt 200"
          city "New York"
          state "New York"
          zip 10065
        end
        skills do
          ruby true
          asp false
          php true
          mysql true
          mongodb true
          haproxy true
          marathon false
        end
        single_skills ['ruby', 'php', 'mysql', 'mongodb', 'haproxy']
        booleans [true, true, false, nil] 
      }
    }
  end
  b.report('Builder') do
    15_000.times {
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.name "Garrett Bjerkhoel"
      xml.birthday Time.local(1991, 9, 14)
      xml.street do
        xml.address "1143 1st Ave"
        xml.address2 "Apt 200"
        xml.city "New York"
        xml.state "New York"
        xml.zip 10065
      end
      xml.skills do
        xml.ruby true
        xml.asp false
        xml.php true
        xml.mysql true
        xml.mongodb true
        xml.haproxy true
        xml.marathon false
      end
      xml.single_skills ['ruby', 'php', 'mysql', 'mongodb', 'haproxy']
      xml.booleans [true, true, false, nil]
      xml.target!
    }
  end
end