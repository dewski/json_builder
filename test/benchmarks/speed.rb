require 'rubygems'
require 'benchmark'
require 'builder'
require 'json_builder'

Benchmark.bm do |b|
  b.report('JSON') do
    5000.times {
      j = JSONBuilder::Generator.new
      j.name "Garrett Bjerkhoel"
      j.birthday Time.local(1991, 9, 14)
      j.street do
        j.address "1143 1st Ave"
        j.address2 "Apt 200"
        j.city "New York"
        j.state "New York"
        j.zip 10065
      end
      j.skills do
        j.ruby true
        j.asp false
        j.php true
        j.mysql true
        j.mongodb true
        j.haproxy true
        j.marathon false
      end
      j.single_skills ['ruby', 'php', 'mysql', 'mongodb', 'haproxy']
      j.booleans [true, true, false, nil]
      j.compile!
    }
  end
  b.report('JSON Pretty') do
    5000.times {
      j = JSONBuilder::Generator.new(:pretty => true)
      j.name "Garrett Bjerkhoel"
      j.birthday Time.local(1991, 9, 14)
      j.street do
        j.address "1143 1st Ave"
        j.address2 "Apt 200"
        j.city "New York"
        j.state "New York"
        j.zip 10065
      end
      j.skills do
        j.ruby true
        j.asp false
        j.php true
        j.mysql true
        j.mongodb true
        j.haproxy true
        j.marathon false
      end
      j.single_skills ['ruby', 'php', 'mysql', 'mongodb', 'haproxy']
      j.booleans [true, true, false, nil]
      j.compile!
    }
  end
  b.report('Builder') do
    5000.times {
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
