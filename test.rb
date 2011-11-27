$:.push File.expand_path('../lib', __FILE__)

require 'json_builder/compiler'

json = JSONBuilder::Compiler.new

json.compile {
  def disabled?
    true
  end

  id 1
  name "Garrett Bjerkhoel"
  email "xhtmlthis@me.com"
  activated true
  blocked { "blocked" }
  banned disabled?
  testing "what" do |hi|
    hi
  end
  posts.array ["test", "test2"] do |post|
    name "Example Post"
    passed_in post
    user_id 1
  end
  urls.array ["http://google.com/", "http://github.com/"] { |url| url }
  meta do
    time = Time.now
    created_at time
    updated_at time
    lols { "WTF" }
    how_meta do
      lol true
      wutdude do
        dude false
      end
    end
  end
  lolwut
  float 14.4
  int 1
  bool_true true
  bool_false false

  # {
  #   "id": 1,
  #   "name": "Garrett Bjerkhoel",
  #   "email": "me+github@garrettbjerkhoel.com",
  #   "activated": true,
  #   "banned": true,
  #   "posts": [{
  #     "name": "Why is JSON Builder Awesome?",
  #     "user_id": 1,
  #     "comments": [{
  #       "user": {
  #         "id": 2,
  #         "name": "John Doe"
  #       },
  #       "body": "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
  #     }]
  #   }],
  #   "urls": ["http://google.com/", "http://github.com/"],
  #   "meta": {
  #     "created_at": "",
  #     "updated_at": ""
  #   }
  # }
}

# json.nodes.each do |node|
#   puts node.key
#   puts node.value
#   puts '*' * 50
# end

puts json.to_s