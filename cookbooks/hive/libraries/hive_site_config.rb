#
#   Copyright (c) 2012-2013 VMware, Inc. All Rights Reserved.
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

module HiveSiteConfiguration

  def update_hive_config
    run_in_ruby_block('update_hive_config_ruby_block') do
      property_kvs = {}
      property_kvs["javax.jdo.option.ConnectionURL"]="jdbc:postgresql://#{node[:ipaddress]}:5432/#{node[:hive][:metastore_db]}"
      property_kvs["javax.jdo.option.ConnectionDriverName"]="org.postgresql.Driver"
      property_kvs["javax.jdo.option.ConnectionUserName"] = "#{node[:hive][:metastore_user]}"
      property_kvs["javax.jdo.option.ConnectionPassword"] = "#{node[:postgresql][:password][:postgres]}"
      property_kvs["hive.metastore.uris"] = ""
      output = generate_hadoop_xml_conf("#{node[:hive][:home_dir]}/conf/hive-site.xml", property_kvs)
      File.open("#{node[:hive][:home_dir]}/conf/hive-site.xml", "w") { |f| f.write(output) }
    end
  end
  
end

class Chef::Recipe
  include HiveSiteConfiguration
end