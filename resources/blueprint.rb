actions :create, :delete
default_action :create

attribute :name				, :name_attribute => true, :kind_of => String, :required => true
attribute :server_fqdn      , :kind_of => String, :default => node[:ambari][:server_fqdn]
attribute :username			, :kind_of => String, :default => node[:ambari][:admin_user]
attribute :password			, :kind_of => String, :default => node[:ambari][:admin_password]
attribute :json				, :kind_of => String, :required => true

attr_accessor :exists