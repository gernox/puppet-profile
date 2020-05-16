require 'spec_helper'

describe 'profile::certificates' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          certificates: {},
        }
      end

      it { is_expected.to compile }
      it { is_expected.to have_profile__cert_resource_count(0) }

      describe 'with multiple certificates' do
        let(:params) do
          {
            certificates: {
              example: {
                private_key: 'priv',
                public_key: 'pub',
              },
              domain: {
                private_key: 'private',
                public_key: 'public',
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_profile__cert_resource_count(2) }
        it {
          is_expected.to contain_file('/etc/ssl/certs/domain.crt')
            .with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0644',
              content: 'public',
            )
        }
        it {
          is_expected.to contain_file('/etc/ssl/private/domain.key')
            .with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0600',
              content: 'private',
            )
        }

        it {
          is_expected.to contain_file('/etc/ssl/certs/example.crt')
            .with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0644',
              content: 'pub',
            )
        }
        it {
          is_expected.to contain_file('/etc/ssl/private/example.key')
            .with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0600',
              content: 'priv',
            )
        }
      end
    end
  end
end
