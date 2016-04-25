# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "maksim"
client_key               "#{current_dir}/maksim.pem"
validation_client_name   "maks-validator"
validation_key           "#{current_dir}/maks-validator.pem"
chef_server_url          "https://chef/organizations/maks"
cookbook_path            ["#{current_dir}/../cookbooks"]
