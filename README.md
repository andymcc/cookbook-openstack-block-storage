Description
===========

Installs the OpenStack Block Storage service **Cinder** as part of the OpenStack reference deployment Chef for OpenStack. The https://github.com/stackforge/openstack-chef-repo contains documentation for using this cookbook in the context of a full OpenStack deployment. Cinder is currently installed from packages.

http://cinder.openstack.org

Requirements
============

* Chef 0.10.0 or higher required (for Chef environment use).

Cookbooks
---------

The following cookbooks are dependencies:

* apt
* openstack-common
* openstack-identity
* openstack-image
* selinux (Fedora)

Usage
=====

api
----
- Installs the cinder-api, sets up the cinder database,
 and cinder service/user/endpoints in keystone

scheduler
----
- Installs the cinder-scheduler service

volume
----
- Installs the cinder-volume service, sets up the iscsi helper and create volume group when using the LVMISCSIDriver

Defaults to the ISCSI (LVM) Driver.

Attributes
==========

* `openstack["block-storage"]["db"]["username"]` - cinder username for database
TODO: Add DB2 support on other platforms
* `openstack["block-storage"]["platform"]["db2_python_packages"]` - Array of DB2 python packages, only available on redhat platform
* `openstack["block-storage"]["volume_name_template"]` - Template string to be used to generate volume names
* `openstack["block-storage"]["snapshot_name_template"]` - Template string to be used to generate snapshot names

MQ attributes
-------------
* `openstack["block-storage"]["mq"]["service_type"]` - Select qpid or rabbitmq. default rabbitmq
TODO: move rabbit parameters under openstack["block-storage"]["mq"]
* `openstack["block-storage"]["rabbit"]["username"]` - Username for nova rabbit access
* `openstack["block-storage"]["rabbit"]["vhost"]` - The rabbit vhost to use
* `openstack["block-storage"]["rabbit"]["port"]` - The rabbit port to use
* `openstack["block-storage"]["rabbit"]["host"]` - The rabbit host to use (must set when `openstack["block-storage"]["rabbit"]["ha"]` false).
* `openstack["block-storage"]["rabbit"]["ha"]` - Whether or not to use rabbit ha

* `openstack["block-storage"]["mq"]["qpid"]["host"]` - The qpid host to use
* `openstack["block-storage"]["mq"]["qpid"]["port"]` - The qpid port to use
* `openstack["block-storage"]["mq"]["qpid"]["qpid_hosts"]` - Qpid hosts. TODO. use only when ha is specified.
* `openstack["block-storage"]["mq"]["qpid"]["username"]` - Username for qpid connection
* `openstack["block-storage"]["mq"]["qpid"]["password"]` - Password for qpid connection
* `openstack["block-storage"]["mq"]["qpid"]["sasl_mechanisms"]` - Space separated list of SASL mechanisms to use for auth
* `openstack["block-storage"]["mq"]["qpid"]["reconnect_timeout"]` - The number of seconds to wait before deciding that a reconnect attempt has failed.
* `openstack["block-storage"]["mq"]["qpid"]["reconnect_limit"]` - The limit for the number of times to reconnect before considering the connection to be failed.
* `openstack["block-storage"]["mq"]["qpid"]["reconnect_interval_min"]` - Minimum number of seconds between connection attempts.
* `openstack["block-storage"]["mq"]["qpid"]["reconnect_interval_max"]` - Maximum number of seconds between connection attempts.
* `openstack["block-storage"]["mq"]["qpid"]["reconnect_interval"]` - Equivalent to setting qpid_reconnect_interval_min and qpid_reconnect_interval_max to the same value.
* `openstack["block-storage"]["mq"]["qpid"]["heartbeat"]` - Seconds between heartbeat messages sent to ensure that the connection is still alive.
* `openstack["block-storage"]["mq"]["qpid"]["protocol"]` - Protocol to use. Default tcp.
* `openstack["block-storage"]["mq"]["qpid"]["tcp_nodelay"]` - Disable the Nagle algorithm. default disabled.

Cinder attributes
-----------------

* `openstack["block-storage"]["service_tenant_name"]` - name of tenant to use for the cinder service account in keystone
* `openstack["block-storage"]["service_user"]` - cinder service user in keystone
* `openstack["block-storage"]["service_role"]` - role for the cinder service user in keystone
* `openstack["block-storage"]["notification_driver"]` - Set the notification driver to be used (default to cinder.openstack.common.notifier.rpc_notifier)
* `openstack["block-storage"]["syslog"]["use"]`
* `openstack["block-storage"]["syslog"]["facility"]`
* `openstack["block-storage"]["syslog"]["config_facility"]`
* `openstack["block-storage"]["platform"]` - hash of platform specific package/service names and options
* `openstack["block-storage"]["volume"]["state_path"]` - Top-level directory for maintaining cinder's state
* `openstack["block-storage"]["volume"]["driver"]` - Driver to use for volume creation
* `openstack["block-storage"]["volume"]["volume_group"]` - Name for the VG that will contain exported volumes
* `openstack["block-storage"]["voluem"]["volume_group_size"]` - The size (GB) of volume group (default is 40)
* `openstack["block-storage"]["voluem"]["create_volume_group"]` - Create volume group or not when using the LVMISCSIDriver (default is false)
* `openstack["block-storage"]["volume"]["iscsi_helper"]` - ISCSI target user-land tool to use
* `openstack["block-storage"]["volume"]["iscsi_ip_address"]` - The IP address where the iSCSI daemon is listening on
* `openstack["block-storage"]["volume"]["iscsi_port"]` - The port where the iSCSI daemon is listening on
* `openstack["block-storage"]["rbd_pool"]` - RADOS Block Device pool to use
* `openstack["block-storage"]["rbd_user"]` - User for Cephx Authentication
* `openstack["block-storage"]["rbd_secret_uuid"]` - Secret UUID for Cephx Authentication
* `openstack["block-storage"]["policy"]["context_is_admin"]` - Define administrators
* `openstack["block-storage"]["policy"]["default"]` - Default volume operations rule
* `openstack["block-storage"]["policy"]["admin_or_owner"]` - Define an admin or owner
* `openstack["block-storage"]["policy"]["admin_api"]` - Define api admin
* `openstack["block-storage"]["netapp"]["protocol"]` - How are we talking to either dfm or filer, http or https
* `openstack["block-storage"]["netapp"]["dfm_hostname"]` - Host or IP of your dfm server
* `openstack["block-storage"]["netapp"]["dfm_login"]` - Username for dfm
* `openstack["block-storage"]["netapp"]["dfm_password"]` - Password for the dfm user
* `openstack["block-storage"]["netapp"]["dfm_port"]` - Default port for dfm
* `openstack["block-storage"]["netapp"]["dfm_web_port"]` - Web gui port for wsdl file download
* `openstack["block-storage"]["netapp"]["storage_service"]` - Name of the service in dfpm
* `openstack["block-storage"]["netapp"]["netapp_server_port"]` - Web admin port of the filer itself
* `openstack["block-storage"]["netapp"]["netapp_server_hostname"]` - Hostname of your filer, needs to be resolvable
* `openstack["block-storage"]["netapp"]["netapp_server_login"]` - Username for netapp filer
* `openstack["block-storage"]["netapp"]["netapp_server_password"]` - Password for user above
* `openstack["block-storage"]["nfs"]["shares_config"]` - File containing line by line entries of server:export
* `openstack["block-storage"]["nfs"]["mount_point_base"]` - Directory to mount NFS exported shares
* `openstack["block-storage"]["rpc_thread_pool_size"]` - Size of RPC thread pool
* `openstack["block-storage"]["rpc_conn_pool_size"]` - Size of RPC connection pool
* `openstack["block-storage"]["rpc_response_timeout"]` - Seconds to wait for a response from call or multicall

### Storwize/SVC attributes ###
* `openstack['block-storage']['san']['san_ip'] - IP address of SAN controller
* `openstack['block-storage']['san']['san_login'] - Username for SAN controller
* `openstack['block-storage']['san']['san_private_key'] - Filename of private key to use for SSH authentication
* `openstack['block-storage']['storwize']['storwize_svc_volpool_name'] - Storage system storage pool for volumes
* `openstack['block-storage']['storwize']['storwize_svc_vol_rsize'] - Storage system space-efficiency parameter for volumes
* `openstack['block-storage']['storwize']['storwize_svc_vol_warning'] - Storage system threshold for volume capacity warnings
* `openstack['block-storage']['storwize']['storwize_svc_vol_autoexpand'] - Storage system autoexpand parameter for volumes
* `openstack['block-storage']['storwize']['storwize_svc_vol_grainsize'] - Storage system grain size parameter for volumes
* `openstack['block-storage']['storwize']['storwize_svc_vol_compression'] - Storage system compression option for volumes
* `openstack['block-storage']['storwize']['storwize_svc_vol_easytier'] - Enable Easy Tier for volumes
* `openstack['block-storage']['storwize']['storwize_svc_vol_iogrp'] - The I/O group in which to allocate volumes
* `openstack['block-storage']['storwize']['storwize_svc_flashcopy_timeout'] - Maximum number of seconds to wait for FlashCopy to be prepared
* `openstack['block-storage']['storwize']['storwize_svc_connection_protocol'] - Connection protocol (iSCSI/FC)
* `openstack['block-storage']['storwize']['storwize_svc_iscsi_chap_enabled'] - Configure CHAP authentication for iSCSI connections
* `openstack['block-storage']['storwize']['storwize_svc_multipath_enabled'] - Connect with multipath (FC only; iSCSI multipath is controlled by Nova)
* `openstack['block-storage']['storwize']['storwize_svc_multihostmap_enabled'] - Allows vdisk to multi host mapping

Testing
=====

Please refer to the [TESTING.md](TESTING.md) for instructions for testing the cookbook.


Berkshelf
=====

Berks will resolve version requirements and dependencies on first run and
store these in Berksfile.lock. If new cookbooks become available you can run
`berks update` to update the references in Berksfile.lock. Berksfile.lock will
be included in stable branches to provide a known good set of dependencies.
Berksfile.lock will not be included in development branches to encourage
development against the latest cookbooks.

License and Author
==================

|                      |                                                    |
|:---------------------|:---------------------------------------------------|
| **Author**           |  Justin Shepherd (<justin.shepherd@rackspace.com>) |
| **Author**           |  Jason Cannavale (<jason.cannavale@rackspace.com>) |
| **Author**           |  Ron Pedde (<ron.pedde@rackspace.com>)             |
| **Author**           |  Joseph Breu (<joseph.breu@rackspace.com>)         |
| **Author**           |  William Kelly (<william.kelly@rackspace.com>)     |
| **Author**           |  Darren Birkett (<darren.birkett@rackspace.co.uk>) |
| **Author**           |  Evan Callicoat (<evan.callicoat@rackspace.com>)   |
| **Author**           |  Matt Ray (<matt@opscode.com>)                     |
| **Author**           |  Jay Pipes (<jaypipes@att.com>)                    |
| **Author**           |  John Dewey (<jdewey@att.com>)                     |
| **Author**           |  Abel Lopez (<al592b@att.com>)                     |
| **Author**           |  Sean Gallagher (<sean.gallagher@att.com>)         |
| **Author**           |  Ionut Artarisi (<iartarisi@suse.cz>)              |
| **Author**           |  David Geng (<gengjh@cn.ibm.com>)                  |
| **Author**           |  Salman Baset (<sabaset@us.ibm.com>)               |
| **Author**           |  Chen Zhiwei (zhiwchen@cn.ibm.com>)                |
|                      |                                                    |
| **Copyright**        |  Copyright (c) 2012, Rackspace US, Inc.            |
| **Copyright**        |  Copyright (c) 2012-2013, AT&T Services, Inc.      |
| **Copyright**        |  Copyright (c) 2013, Opscode, Inc.                 |
| **Copyright**        |  Copyright (c) 2013, SUSE Linux GmbH               |
| **Copyright**        |  Copyright (c) 2013, IBM, Corp.                    |

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
