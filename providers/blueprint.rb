require 'net/http'
require 'uri'
require 'json'

action :create do
  url = URI("http://" + new_resource.server_fqdn + ":8080/api/v1/blueprints/" + new_resource.name)
  http =  Net::HTTP.new(new_resource.server_fqdn,8080)
  
  Chef::Log.info "Attempting to create blueprint '#{new_resource.name}'"
  request = Net::HTTP::Post.new(url)
  request.basic_auth(new_resource.username,new_resource.password)
  request.add_field("X-Requested-By", "ambari-cookbook")
  request.body = new_resource.json
  Chef::Log.debug "request json: #{request.body}"
  
  resp = http.request(request)
  if resp.code == '201' then
    Chef::Log.info "Blueprint '#{new_resource.name}' created"
  elsif resp.code == '409' then
    Chef::Log.info "Blueprint already exists"
  else
    resp_body = JSON.parse(resp.body)
	Chef::Log.error "#{resp_body['status']}:#{resp_body['message']}"
	raise "#{resp_body['status']}:#{resp_body['message']}"
  end
end


action :delete do
  url = URI("http://" + new_resource.server_fqdn + ":8080/api/v1/blueprints/" + new_resource.name)
  http =  Net::HTTP.new(new_resource.server_fqdn,8080)
  
  Chef::Log.info "Attempting to delete blueprint '#{new_resource.name}'"
  request = Net::HTTP::Delete.new(url)
  request.basic_auth(new_resource.username,new_resource.password)
  request.add_field("X-Requested-By", "ambari-cookbook")
  
  resp = http.request(request)
  Chef::Log.debug "response code: #{resp.code}"
  if resp.code == '200' then
    Chef::Log.info "Blueprint '#{new_resource.name}' deleted"
  else
    resp_body = JSON.parse(resp.body)
	Chef::Log.error "#{resp_body['status']}:#{resp_body['message']}"
	raise "#{resp_body['status']}:#{resp_body['message']}"
  end
end


