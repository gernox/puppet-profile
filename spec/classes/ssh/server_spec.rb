require 'spec_helper'

describe 'profile::ssh::server', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'passing authorized_keys parameter with no entries' do
        let(:params) do
          {
            authorized_keys: {},
          }
        end

        it { is_expected.to compile.with_all_deps }
        it {
          is_expected.to contain_file('/etc/motd')
            .with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
            )
        }
        it { is_expected.to have_ssh_authorized_key_resource_count(0) }
        it { is_expected.to contain_class('ssh::server') }
      end

      describe 'passing authorized_keys parameter with two entries' do
        let(:params) do
          {
            authorized_keys: {
              foo: {
                user: 'user1',
              },
              bar: {
                user: 'user2',
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_ssh_authorized_key_resource_count(2) }
        it { is_expected.to contain_ssh_authorized_key('foo') }
        it { is_expected.to contain_ssh_authorized_key('bar') }
      end
    end
  end
end
