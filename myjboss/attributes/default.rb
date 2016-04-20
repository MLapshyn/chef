default['jboss']['version'] = "5.1.0.GA"
default['jboss']['url'] = " http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip/download"
default['jboss']['app_url'] = "http://www.cumulogic.com/download/Apps/testweb.zip"
default['jboss']['target_dir'] = "/opt"
default['jboss']['jboss_home'] = "#{ node['jboss']['install_path'] }/jboss-5.1.0.GA"
default['jboss']['deploy_path'] = "#{ node['jboss']['jboss_home'] }/server/default/deploy"
default['jboss']['server_configuration'] = "default"
default['jboss']['jboss_user'] = "jboss"
default['jboss']['jboss_group'] = "jboss"
default['jboss'][':bind_address']="192.168.56.22"




