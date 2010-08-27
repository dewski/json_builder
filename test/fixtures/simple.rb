require 'json_builder'
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
j.hashed {
  :my_name => "Garrett Bjerkhoel".split('')
}
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

puts j.compile!
