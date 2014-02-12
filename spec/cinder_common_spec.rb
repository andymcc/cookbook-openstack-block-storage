# encoding: UTF-8
#
# Cookbook Name:: openstack-block-storage

require_relative 'spec_helper'

describe 'openstack-block-storage::cinder-common' do
  before { block_storage_stubs }
  before do
    @chef_run = ::ChefSpec::Runner.new ::UBUNTU_OPTS do |n|
      n.set['openstack']['mq'] = {
        'host' => '127.0.0.1'
      }

    end
    @chef_run.converge 'openstack-block-storage::cinder-common'
  end

  it 'installs the cinder-common package' do
    expect(@chef_run).to upgrade_package 'cinder-common'
  end

  describe '/etc/cinder' do
    before do
      @dir = @chef_run.directory '/etc/cinder'
    end

    it 'has proper owner' do
      expect(@dir.owner).to eq('cinder')
      expect(@dir.group).to eq('cinder')
    end

    it 'has proper modes' do
      expect(sprintf('%o', @dir.mode)).to eq '750'
    end
  end

  describe 'cinder.conf' do
    before do
      @file = @chef_run.template '/etc/cinder/cinder.conf'
    end

    it 'has proper owner' do
      expect(@file.owner).to eq('cinder')
      expect(@file.group).to eq('cinder')
    end

    it 'has proper modes' do
      expect(sprintf('%o', @file.mode)).to eq '644'
    end

    it 'has name templates' do
      expect(@chef_run).to render_file(@file.name).with_content('volume_name_template=volume-%s')
      expect(@chef_run).to render_file(@file.name).with_content('snapshot_name_template=snapshot-%s')
    end

    it 'has rpc_backend set' do
      expect(@chef_run).to render_file(@file.name).with_content('rpc_backend=cinder.openstack.common.rpc.impl_kombu')
    end

    it 'has has volumes_dir set' do
      expect(@chef_run).to render_file(@file.name).with_content('volumes_dir=/var/lib/cinder/volumes')
    end

    it 'has correct volume.driver set' do
      expect(@chef_run).to render_file(@file.name).with_content('volume_driver=cinder.volume.drivers.lvm.LVMISCSIDriver')
    end

    it 'has rpc_thread_pool_size' do
      expect(@chef_run).to render_file(@file.name).with_content('rpc_thread_pool_size=64')
    end

    it 'has rpc_conn_pool_size' do
      expect(@chef_run).to render_file(@file.name).with_content('rpc_conn_pool_size=30')
    end

    it 'has rpc_response_timeout' do
      expect(@chef_run).to render_file(@file.name).with_content('rpc_response_timeout=60')
    end

    it 'has rabbit_host' do
      expect(@chef_run).to render_file(@file.name).with_content('rabbit_host=127.0.0.1')
    end

    it 'does not have rabbit_hosts' do
      expect(@chef_run).not_to render_file(@file.name).with_content('rabbit_hosts=')
    end

    it 'does not have rabbit_ha_queues' do
      expect(@chef_run).not_to render_file(@file.name).with_content('rabbit_ha_queues=')
    end

    it 'has log_file' do
      expect(@chef_run).to render_file(@file.name).with_content('log_file = /var/log/cinder/cinder.log')
    end

    it 'has log_config when syslog is true' do
      chef_run = ::ChefSpec::Runner.new ::UBUNTU_OPTS do |n|
        n.set['openstack']['block-storage']['syslog']['use'] = true
      end
      chef_run.converge 'openstack-block-storage::cinder-common'

      expect(chef_run).to render_file(@file.name).with_content('log_config = /etc/openstack/logging.conf')
    end

    it 'has rabbit_port' do
      expect(@chef_run).to render_file(@file.name).with_content('rabbit_port=5672')
    end

    it 'has rabbit_use_ssl' do
      expect(@chef_run).to render_file(@file.name).with_content('rabbit_use_ssl=false')
    end

    it 'has rabbit_userid' do
      expect(@chef_run).to render_file(@file.name).with_content('rabbit_userid=guest')
    end

    it 'has rabbit_password' do
      expect(@chef_run).to render_file(@file.name).with_content('rabbit_password=rabbit-pass')
    end

    it 'has rabbit_virtual_host' do
      expect(@chef_run).to render_file(@file.name).with_content('rabbit_virtual_host=/')
    end

    describe 'rabbit ha' do
      before do
        @chef_run = ::ChefSpec::Runner.new(::UBUNTU_OPTS) do |n|
          n.set['openstack']['mq']['block-storage']['rabbit']['ha'] = true
        end
        @chef_run.converge 'openstack-block-storage::cinder-common'
      end

      it 'has rabbit_hosts' do
        expect(@chef_run).to render_file(@file.name).with_content('rabbit_hosts=1.1.1.1:5672,2.2.2.2:5672')
      end

      it 'has rabbit_ha_queues' do
        expect(@chef_run).to render_file(@file.name).with_content('rabbit_ha_queues=True')
      end

      it 'does not have rabbit_host' do
        expect(@chef_run).not_to render_file(@file.name).with_content('rabbit_host=127.0.0.1')
      end

      it 'does not have rabbit_port' do
        expect(@chef_run).not_to render_file(@file.name).with_content('rabbit_port=5672')
      end
    end

    describe 'qpid' do
      before do
        @file = @chef_run.template '/etc/cinder/cinder.conf'
        @chef_run.node.set['openstack']['mq']['block-storage']['service_type'] = 'qpid'
        @chef_run.node.set['openstack']['block-storage']['notification_driver'] = 'cinder.test_driver'
        @chef_run.converge 'openstack-block-storage::cinder-common'
      end

      it 'has qpid_hostname' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_hostname=127.0.0.1')
      end

      it 'has qpid_port' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_port=5672')
      end

      it 'has qpid_username' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_username=')
      end

      it 'has qpid_password' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_password=')
      end

      it 'has qpid_sasl_mechanisms' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_sasl_mechanisms=')
      end

      it 'has qpid_reconnect_timeout' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_reconnect_timeout=0')
      end

      it 'has qpid_reconnect_limit' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_reconnect_limit=0')
      end

      it 'has qpid_reconnect_interval_min' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_reconnect_interval_min=0')
      end

      it 'has qpid_reconnect_interval_max' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_reconnect_interval_max=0')
      end

      it 'has qpid_reconnect_interval' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_reconnect_interval=0')
      end

      it 'has qpid_reconnect' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_reconnect=true')
      end

      it 'has qpid_heartbeat' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_heartbeat=60')
      end

      it 'has qpid_protocol' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_protocol=tcp')
      end

      it 'has qpid_tcp_nodelay' do
        expect(@chef_run).to render_file(@file.name).with_content('qpid_tcp_nodelay=true')
      end

      it 'has notification_driver' do
        expect(@chef_run).to render_file(@file.name).with_content('notification_driver=cinder.test_driver')
      end
    end

    describe 'solidfire settings' do
      before do
        @chef_run.node.set['openstack']['block-storage']['volume']['driver'] = 'cinder.volume.drivers.solidfire.SolidFire'
        @chef_run.node.set['openstack']['block-storage']['solidfire']['sf_emulate'] = 'test'
        @chef_run.node.set['openstack']['block-storage']['solidfire']['san_ip'] = '203.0.113.10'
        @chef_run.node.set['openstack']['block-storage']['solidfire']['san_login'] = 'solidfire_admin'
        @chef_run.converge 'openstack-block-storage::cinder-common'
      end

      it 'has solidfire sf_emulate set' do
        expect(@chef_run).to render_file(@file.name).with_content('sf_emulate_512=test')
      end

      it 'has solidfire san_ip set' do
        expect(@chef_run).to render_file(@file.name).with_content('san_ip=203.0.113.10')
      end

      it 'has solidfire san_login' do
        expect(@chef_run).to render_file(@file.name).with_content('san_login=solidfire_admin')
      end

      it 'has solidfire password' do
        expect(@chef_run).to render_file(@file.name).with_content('san_password=solidfire_testpass')
      end

      it 'does not have iscsi_ip_prefix not specified' do
        expect(@chef_run).to_not render_file(@file.name).with_content('iscsi_ip_prefix')
      end

      it 'does have iscsi_ip_prefix when specified' do
        @chef_run.node.set['openstack']['block-storage']['solidfire']['iscsi_ip_prefix'] = '203.0.113.*'

        expect(@chef_run).to render_file(@file.name).with_content('iscsi_ip_prefix=203.0.113.*')
      end
    end
  end

  describe '/var/lock/cinder' do
    before do
      @dir = @chef_run.directory '/var/lock/cinder'
    end

    it 'has proper owner' do
      expect(@dir.owner).to eq('cinder')
      expect(@dir.group).to eq('cinder')
    end

    it 'has proper modes' do
      expect(sprintf('%o', @dir.mode)).to eq '700'
    end
  end

end
