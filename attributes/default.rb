#
# Author:: Taliesin Sisson (<taliesins@yahoo.com>)
# Cookbook Name:: sagecrm
# Attributes:: default
# Copyright 2014-2015, Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


default['sagecrm']['name'] = 'sagecrm'
default['sagecrm']['filename'] = 'SageCrm7.2a.1'
default['sagecrm']['filenameextension'] = 'zip'
default['sagecrm']['url'] = 'http://www.yourserver.com/' + default['sagecrm']['filename'] + '.' + default['sagecrm']['filenameextension'] 
default['sagecrm']['checksum'] = '818241f5fb614371958e19cbedd85ab286a69e31fed1f7cde544885952d22d2d'
default['sagecrm']['home'] = "#{Chef::Config['file_cache_path']}/#{node['sagecrm']['filename']}/#{node['sagecrm']['checksum']}"


default['sagecrm']['service']['account'] = '.\SageCRM' # e.g. SageCRM. This account is used to access the database server, so ensure that database permission have been configured. This account is used to run service, so ensure that it has the correct permissions on each node. If using multiple nodes, active directory is required.
default['sagecrm']['service']['password'] = 'P@ssw0rd' # e.g. P@ssw0rd. This is the password to use if creating a windows account locally to use.
default['sagecrm']['service']['group'] = 'Administrators'

username = node['sagecrm']['service']['account']
domain = ""

if username.include? '\\'
	domain = username.split('\\')[0]
	username = username.split('\\')[1]
end

if username.include? '@'
	domain = username.split('@')[1]
	username = username.split('@')[0]
end

if domain == ""  || domain == "."
	domain = node["hostname"]
end

default['sagecrm']['database']['sys_roles'] = {:sysadmin => :ADD}
default['sagecrm']['database']['host'] = '127.0.0.1'
default['sagecrm']['database']['port'] = node['sql_server']['port']
default['sagecrm']['database']['username'] = nil
default['sagecrm']['database']['password'] = nil

default['sagecrm']['database']['windows_user'] = true
default['sagecrm']['database']['account'] = "#{domain}\\#{username}"

default['sagecrm']['instance']['FarmDns'] = node['fqdn']  # e.g. servicebus.localtest.me
default['sagecrm']['instance']['FarmCertificateThumbprint'] = '' # if sagecrm::certificate is called it will populate this field e.g. wildcard certificate *.localtest.me thumbprint 

default['sagecrm']['certificate']['CaCertificate']['common_name'] = node['sagecrm']['instance']['FarmDns'] + '.ca'
default['sagecrm']['certificate']['CaCertificate']['key_source'] = 'self-signed'
default['sagecrm']['certificate']['CaCertificate']['pkcs12_path'] = File.join(Chef::Config[:file_cache_path], node['sagecrm']['certificate']['CaCertificate']['common_name'] + '.pfx')
default['sagecrm']['certificate']['CaCertificate']['pkcs12_passphrase'] = nil
default['sagecrm']['certificate']['CaCertificate']['private_key_acl'] = ["#{domain}\\#{username}", "#{domain}\\vagrant"]
default['sagecrm']['certificate']['CaCertificate']['store_name'] = "ROOT"
default['sagecrm']['certificate']['CaCertificate']['user_store'] = false
default['sagecrm']['certificate']['CaCertificate']['cert_path'] = File.join(Chef::Config[:file_cache_path], node['sagecrm']['certificate']['CaCertificate']['common_name'] + '.pem')
default['sagecrm']['certificate']['CaCertificate']['key_path'] = File.join(Chef::Config[:file_cache_path], node['sagecrm']['certificate']['CaCertificate']['common_name'] + '.key')

default['sagecrm']['certificate']['FarmCertificate']['common_name'] = node['sagecrm']['instance']['FarmDns']
default['sagecrm']['certificate']['FarmCertificate']['cert_source'] = 'with_ca'
default['sagecrm']['certificate']['FarmCertificate']['pkcs12_path'] = File.join(Chef::Config[:file_cache_path], node['sagecrm']['certificate']['FarmCertificate']['common_name'] + '.pfx')
default['sagecrm']['certificate']['FarmCertificate']['pkcs12_passphrase'] = nil
default['sagecrm']['certificate']['FarmCertificate']['private_key_acl'] = ["#{domain}\\#{username}", "#{domain}\\vagrant"]
default['sagecrm']['certificate']['FarmCertificate']['store_name'] = "MY"
default['sagecrm']['certificate']['FarmCertificate']['user_store'] = false
default['sagecrm']['certificate']['FarmCertificate']['ca_cert_path'] = node['sagecrm']['certificate']['CaCertificate']['cert_path']
default['sagecrm']['certificate']['FarmCertificate']['ca_key_path'] = node['sagecrm']['certificate']['CaCertificate']['key_path']

default['sagecrm']['windows_features'] = ['IIS-WebServerRole', 'IIS-WebServer', 'IIS-CommonHttpFeatures', 'IIS-HttpErrors', 'IIS-ApplicationDevelopment', 'IIS-RequestFiltering', 'IIS-NetFxExtensibility', 'IIS-HealthAndDiagnostics', 'IIS-HttpLogging', 'IIS-Security', 'IIS-RequestMonitor', 'IIS-Performance', 'NetFx3', 'NetFx3ServerFeatures', 'IIS-StaticContent', 'IIS-DefaultDocument', 'IIS-WebSockets', 'IIS-WebServerManagementTools', 'IIS-ManagementConsole', 'IIS-ManagementService', 'IIS-IIS6ManagementCompatibility','IIS-Metabase', 'IIS-ISAPIExtensions', 'IIS-ISAPIFilter', 'IIS-StaticContent', 'IIS-DefaultDocument', 'IIS-DirectoryBrowsing', 'IIS-ASPNET', 'IIS-ASP', 'IIS-CGI', 'IIS-ServerSideIncludes', 'IIS-BasicAuthentication', 'IIS-HttpCompressionStatic', 'IIS-ManagementConsole', 'IIS-WMICompatibility', 'IIS-LegacyScripts', 'IIS-LegacySnapIn', 'NetFx3', 'SNMP',  'Printing-XPSServices-Features', 'IIS-WindowsAuthentication']