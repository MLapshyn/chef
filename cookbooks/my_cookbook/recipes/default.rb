#
# Cookbook Name:: exit_task_cookbook
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#INSTALL JAVA 1.7
yum_package 'java-1.7.0-openjdk-devel' do
	package_name 'java-1.7.0-openjdk-devel'
	action :install
end
#INSTALL GIT
yum_package 'git' do
	package_name 'git'
	action :install
end
#NGINX REPO
template '/etc/yum.repos.d/nginx.repo' do
	source 'nginx.repo.erb'
end
#INSTALL NGINX
yum_package 'nginx' do
	package_name 'nginx'
	action :install
end
#VHOSTs FILE
template '/etc/nginx/conf.d/vhost.conf' do
	source 'vhost.erb'
end
#JENKINS REPO
template "/etc/yum.repos.d/jenkins.repo" do
	source "jenkins.repo.erb"
end

remote_directory '/var/lib/jenkins' do
	source 'jenkins'

end
#INSTALL JENKINS
yum_package 'jenkins' do
	package_name 'jenkins'
	action :install
	notifies :run, 'execute[chown_jenkins]', :immediately
end
#JENKINS CONFIG
template "/etc/sysconfig/jenkins" do
  source "jenkins.erb"
  mode 0600
end
#JENKINS OWNER
execute 'chown_jenkins' do
	command "chown -R jenkins:jenkins /var/lib/jenkins"
	action :nothing
end
#ADD JENKINS USER TO SUDOERS
template '/etc/sudoers.d/jenkins' do
	source 'jenkins_sudoers.erb'
end
#CREATE TOMCAT USER
user 'tomcat' do
	comment 'Tomcat user'
	home '/home/tomcat'
	shell '/bin/bash'
	action :create
end
#CREATE TOMCAT GROUP
group 'tomcat' do
	action :create
	members 'tomcat'
	append true
end
#TOMCAT TAR
remote_file '/opt/apache-tomcat-7.0.61.tar.gz' do
	source 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.61/bin/apache-tomcat-7.0.61.tar.gz'
	action :create
	notifies :run, 'execute[extract_tomcat]', :immediately
end
#INSTALL TOMCAT
execute 'extract_tomcat' do
	command 'tar -xf /opt/apache-tomcat-7.0.61.tar.gz -C /opt/'
	action :nothing
	notifies :run, 'execute[chown_tomcat]', :immediately
end
#TOMCAT OWNER
execute "chown_tomcat" do
	command "chown -R tomcat:tomcat /opt/apache-tomcat-7.0.61"
	action :nothing
end
#TOMCAT AS SERVICE
template "/etc/init.d/tomcat" do
	source "tomcat.erb"
	mode 0775
	owner 'root'
    group 'root'
end
#SERVER CONFIG
template "/opt/apache-tomcat-7.0.61/conf/server.xml" do
	source "server.erb"
	owner "tomcat"
	group "tomcat"
end
#MAVEN TAR
remote_file '/opt/apache-maven-3.3.9-bin.tar.gz' do
	source 'http://ftp.byfly.by/pub/apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz'
	action :create
	notifies :run, 'execute[extract_maven]', :immediately
end
#INSTALL MAVEN
execute "extract_maven" do
	command "tar -xf /opt/apache-maven-3.3.9-bin.tar.gz -C /opt/"
	action :nothing
end

#STARTING SERVICES
#NGINX
service 'nginx' do
	action [ :enable, :start]
end
#JENKINS
service 'jenkins' do
	action [ :enable, :start]
end
#TOMCAT
service 'tomcat' do
	action [ :enable, :start]
end
