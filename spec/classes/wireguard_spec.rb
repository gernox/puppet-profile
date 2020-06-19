require 'spec_helper'

describe 'profile::wireguard' do
  let(:pre_condition) { "include '::profile' ; profile::package {'linux-headers-generic': }" }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          public_key: 'PUBLIC',
          private_key: 'PRIVATE',
          internal_ip: '127.0.0.2',
        }
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
