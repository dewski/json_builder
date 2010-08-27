json.id 1337
json.name 'BKWLD'
json.slug 'BKWLD'
json.subdomain 'bkwld'
json.hosted_domain 'custom.bkwld.com'
json.clients_count 15
json.last_billed_on 30.days.ago
json.skills ['php', 'mysql', 'css', 'html', 'etc']
json.owner do
  render :partial => 'user', :object => User.first, :locals => { :json => json }
end