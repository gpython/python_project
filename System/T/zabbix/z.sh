getUserAuth.sh
 
#!/bin/bash
curl -i -X POST -H 'Content-Type:application/json' -d'{"jsonrpc": "2.0","method":"user.authenticate","params":{"user":"Admin","password":"zabbix"},"auth": null,"id":0}' http://127.0.0.1/zabbix/api_jsonrpc.php
The response to this query has the following result, which is the output of the executed shell script “getUserAuth.sh”:
 
{"jsonrpc":"2.0","result":"6705db5c5bdbd1d02a1f53857be6b200","id":0}
This result is used for further JSON RPC queries. To get information about a specific host, in addition to user authentication information, the name of the host should be given in the JSON RPC query. “host.get” method is used to get information about a specific host. Use the parameter “host” to give the host name, in the following example the host name is “Zabbix server”:
 
getHost.sh
 
#!/bin/bash
curl -i -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"host.get","params":{"output":"extend","filter":{"host":"Zabbix server"}},"auth":"6705db5c5bdbd1d02a1f53857be6b200","id":1}' http://127.0.0.1/zabbix/api_jsonrpc.php
After executing the “getHost.sh” script, the response to the JSON RPC query has the following result:
 
{"jsonrpc":"2.0","result":[{"maintenances":[{"maintenanceid":"0"}],"hostid":"10017","proxy_hostid":"0","host":"Zabbix server","dns":"","useip":"1","ip":"127.0.0.1","port":"10050","status":"0","disable_until":"0","error":"","available":"1","errors_from":"0","lastaccess":"0","inbytes":"0","outbytes":"0","useipmi":"0","ipmi_port":"623","ipmi_authtype":"0","ipmi_privilege":"2","ipmi_username":"","ipmi_password":"","ipmi_disable_until":"0","ipmi_available":"0","snmp_disable_until":"0","snmp_available":"0","maintenanceid":"0","maintenance_status":"0","maintenance_type":"0","maintenance_from":"0","ipmi_ip":"","ipmi_errors_from":"0","snmp_errors_from":"0","ipmi_error":"","snmp_error":""}],"id":1}
This result includes information about the host. The “hostid”:”10017”, is one of the information parameters, which can be used for further request along with user authentication results.
 
To monitor any resource (item), “item.get” is used as the method of JSON RPC query. The authentication result and the host ID received from the previous JSON RPC queries are used as input to some parameters of the JSON RPC query in the following getItemID.sh script, which is used to get item ID. However, when using JSON RPC to invoke Zabbix API, the parameter “key_” is used for filtering monitoring information. For instance, to get only the monitoring information about the item “Used disk space on /usr”, the “key_” should be set to “vfs.fs.size[/usr,used]”.
 
getItemID.sh
 
#!/bin/bash
curl -i -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"item.get","params":{"output":"extend","filter":{"key\_":"vfs.fs.size[/usr,used]","hostid":"10017"}},"auth":"6705db5c5bdbd1d02a1f53857be6b200","id":2}' http://127.0.0.1/zabbix/api_jsonrpc.php
After executing the “getItemID.sh” script, the response to the JSON RPC query has the following result:
 
{"jsonrpc":"2.0","result":[{"hosts":[{"hostid":"10017"}],"itemid":"18527","type":"0","snmp_community":"","snmp_oid":"","snmp_port":"161","hostid":"10017","description":"Used disk space on  $1","key\_":"vfs.fs.size[\/usr,used]","delay":"30","history":"7","trends":"365","lastvalue":"9679056896","lastclock":"1309102427","prevvalue":"9679060992","status":"0","value_type":"3","trapper_hosts":"","units":"B","multiplier":"0","delta":"0","prevorgvalue":null,"snmpv3_securityname":"","snmpv3_securitylevel":"0","snmpv3_authpassphrase":"","snmpv3_privpassphrase":"","formula":"","error":"","lastlogsize":"0","logtimefmt":"","templateid":"10416","valuemapid":"0","delay_flex":"","params":"","ipmi_sensor":"","data_type":"0","authtype":"0","username":"","password":"","publickey":"","privatekey":"","mtime":"0"}],"id":2}
If one needs to know a list of all available items and their corresponding keys before looking for a specific item, one can find this in two ways:
 
On the Zabbix GUI: go to Configuration/Hosts/ then click on the items of the target host, you will find the description of items (e.g. “Used disk space on /usr”) with their corresponding keys (e.g. “vfs.fs.size[/usr,used]”).
If you don’t have the ability to see the GUI, which means that you only use remote calls (JSON-RPC) through Zabbix API using curl, you can execute, for example, the following shell script:
getAvailableItems.sh
 
#!/bin/bash
curl -i -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"item.get","params":{"output":"extend","filter":{"hostid":"10017"}},"auth":"6705db5c5bdbd1d02a1f53857be6b200","id":2}' http://127.0.0.1/zabbix/api_jsonrpc.php
When you execute this shell script, you will get all items (their descriptions and keys) as a response to the JSON-RPC request.
 
Since the returned result as a response to the JSON RPC query is too long, the following is the last part of that result:
 
{"jsonrpc":"2.0","result":[{".......................":"................."},{"hosts":[{"hostid":"10017"}],"itemid":"18535","type":"0","snmp_community":"","snmp_oid":"","snmp_port":"161","hostid":"10017","description":"Shared memory","key_":"vm.memory.size[shared]","delay":"30","history":"7","trends":"365","lastvalue":"0","lastclock":"1310472865","prevvalue":"0","status":"0","value_type":"3","trapper_hosts":"","units":"B","multiplier":"0","delta":"0","prevorgvalue":null,"snmpv3_securityname":"","snmpv3_securitylevel":"0","snmpv3_authpassphrase":"","snmpv3_privpassphrase":"","formula":"0","error":"","lastlogsize":"0","logtimefmt":"","templateid":"10027","valuemapid":"0","delay_flex":"","params":"","ipmi_sensor":"","data_type":"0","authtype":"0","username":"","password":"","publickey":"","privatekey":"","mtime":"0"},{"hosts":[{"hostid":"10017"}],"itemid":"18536","type":"0","snmp_community":"","snmp_oid":"","snmp_port":"161","hostid":"10017","description":"Total memory","key_":"vm.memory.size[total]","delay":"1800","history":"7","trends":"365","lastvalue":"1038831616","lastclock":"1310472536","prevvalue":"1038831616","status":"0","value_type":"3","trapper_hosts":"","units":"B","multiplier":"0","delta":"0","prevorgvalue":null,"snmpv3_securityname":"","snmpv3_securitylevel":"0","snmpv3_authpassphrase":"","snmpv3_privpassphrase":"","formula":"0","error":"","lastlogsize":"0","logtimefmt":"","templateid":"10026","valuemapid":"0","delay_flex":"","params":"","ipmi_sensor":"","data_type":"0","authtype":"0","username":"","password":"","publickey":"","privatekey":"","mtime":"0"}],"id":2}
To monitor the history of the any item, the “history.get” method is used in the JSPN RPC queries. If we want to monitor the history of, for instance, the item “Used disk space on /usr”, the JSON RPC query should include user authentication result, host ID and item IDs gained from previous JSON RPC queries. The “getHistory.sh” script can be executed to get history information about the “Used disk space on /usr” within the period of time [26.06.2011/01:00 pm, 26.06.2011/01:10 pm] (Note: this period of time is converted to UNIX timestamps through UNIX timestamp converter). Moreover, the parameter “history” of the “history.get” JSON RPC query should set to the item value type. This value is included in the response to the “item.get” JSON RPC query under the name “value_type”.
 
In Zabbix, the following value_types are defined:
 
define(‘ITEM_VALUE_TYPE_FLOAT’, 0);
define(‘ITEM_VALUE_TYPE_STR’, 1);
define(‘ITEM_VALUE_TYPE_LOG’, 2);
define(‘ITEM_VALUE_TYPE_UINT64’, 3);
define(‘ITEM_VALUE_TYPE_TEXT’, 4);
getHistory.sh
 
#!/bin/bash
curl -i -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"history.get","params":{"itemids":[18527],"history":3,"output":"extend","time_from":"1309086000","time_till":"1309086600"},"auth":"6705db5c5bdbd1d02a1f53857be6b200","id":2}' http://127.0.0.1/zabbix/api_jsonrpc.php
The response to “history.get” query after executing “getHistory.sh” has the following result:
 
{"jsonrpc":"2.0","result":[{"itemid":"18527","clock":"1309086017","value":"9675649024"},{"itemid":"18527","clock":"1309086047","value":"9675649024"},{"itemid":"18527","clock":"1309086077","value":"9675665408"},{"itemid":"18527","clock":"1309086107","value":"9675665408"},{"itemid":"18527","clock":"1309086137","value":"9675685888"},{"itemid":"18527","clock":"1309086167","value":"9675698176"},{"itemid":"18527","clock":"1309086197","value":"9675706368"},{"itemid":"18527","clock":"1309086227","value":"9675726848"},{"itemid":"18527","clock":"1309086257","value":"9675751424"},{"itemid":"18527","clock":"1309086287","value":"9675739136"},{"itemid":"18527","clock":"1309086317","value":"9675739136"},{"itemid":"18527","clock":"1309086347","value":"9675751424"},{"itemid":"18527","clock":"1309086377","value":"9675763712"},{"itemid":"18527","clock":"1309086407","value":"9675759616"},{"itemid":"18527","clock":"1309086437","value":"9675767808"},{"itemid":"18527","clock":"1309086467","value":"9675776000"},{"itemid":"18527","clock":"1309086497","value":"9675796480"},{"itemid":"18527","clock":"1309086527","value":"9675833344"},{"itemid":"18527","clock":"1309086557","value":"9675833344"},{"itemid":"18527","clock":"1309086587","value":"9675837440"}],"id":2}
Important things to be noticed regarding “history.get”:
 
“history.get” functionality is not implemented only since version: 1.8.3. If you use, lower version of Zabbix, like 1.8.2, the response to the “history.get” JSON RPC query will be:
{"jsonrpc":"2.0","error":{"code":-32602,"message":"Invalid params.","data":"Resource (history) does not exist"},"id":2}
Fetching history info about multiple metrics is not possible using one JSON RPC query. In Zabbix documentation, it’s clear written that “Getting values for multiple items of different types (history parameter) is not supported at this time”.
Link to these infos: http://www.zabbix.com/documentation/1.8/api/history/get
 

