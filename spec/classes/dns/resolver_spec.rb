require 'spec_helper'

describe 'profile::dns::resolver', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('dns_resolver_config_file')
            .with(
              ensure: 'file',
              path: '/etc/resolv.conf',
              owner: 'root',
              group: 'root',
              mode: '0644',
            )
        }
        it {
          is_expected.to contain_file('dns_resolver_config_file')
            .with_content(%(# This file is being managed by Puppet.
# DO NOT EDIT
options rotate timeout:1
nameserver 46.182.19.48
nameserver 91.239.100.100
nameserver 89.233.43.71
))
        }
      end

      describe 'passing nameservers parameter' do
        let(:params) { { nameservers: ['4.2.2.2', '4.2.2.1'] } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('dns_resolver_config_file')
            .with_content(%(# This file is being managed by Puppet.
# DO NOT EDIT
options rotate timeout:1
nameserver 4.2.2.2
nameserver 4.2.2.1
))
        }
      end

      describe 'passing nameservers parameter with a single entry' do
        let(:params) { { nameservers: ['1.2.3.4'] } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('dns_resolver_config_file')
            .with_content(%(# This file is being managed by Puppet.
# DO NOT EDIT
options rotate timeout:1
nameserver 1.2.3.4
))
        }
      end

      describe 'passing options parameter' do
        let(:params) { { options: ['ndots:2'] } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('dns_resolver_config_file')
            .with_content(%(# This file is being managed by Puppet.
# DO NOT EDIT
options ndots:2
nameserver 46.182.19.48
nameserver 91.239.100.100
nameserver 89.233.43.71
))
        }
      end

      describe 'passing search parameter' do
        let(:params) { { search: ['foo.example.com', 'example.com'] } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('dns_resolver_config_file')
            .with_content(%(# This file is being managed by Puppet.
# DO NOT EDIT
search foo.example.com example.com
options rotate timeout:1
nameserver 46.182.19.48
nameserver 91.239.100.100
nameserver 89.233.43.71
))
        }
      end

      describe 'passing domain parameter' do
        let(:params) { { domain: 'example.com' } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('dns_resolver_config_file')
            .with_content(%(# This file is being managed by Puppet.
# DO NOT EDIT
domain example.com
options rotate timeout:1
nameserver 46.182.19.48
nameserver 91.239.100.100
nameserver 89.233.43.71
))
        }
      end

      describe 'passing sortlist parameter' do
        let(:params) { { sortlist: ['10.10.10.0/24', '10.10.11.0/24'] } }

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('dns_resolver_config_file')
            .with_content(%(# This file is being managed by Puppet.
# DO NOT EDIT
sortlist 10.10.10.0/24 10.10.11.0/24
options rotate timeout:1
nameserver 46.182.19.48
nameserver 91.239.100.100
nameserver 89.233.43.71
))
        }
      end

      describe 'passing resolver_config_file parameters' do
        let(:params) do
          {
            resolver_config_file: '/etc/resolv_test.conf',
            resolver_config_file_ensure: 'present',
            resolver_config_file_owner: 'owner',
            resolver_config_file_group: 'group',
            resolver_config_file_mode: '0777',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('dns_resolver_config_file')
            .with(
              ensure: 'present',
              path: '/etc/resolv_test.conf',
              owner: 'owner',
              group: 'group',
              mode: '0777',
            )
        }
      end
    end
  end
end
