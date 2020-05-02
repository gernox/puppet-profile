require 'spec_helper'

describe 'profile::wireguard' do
  let(:pre_condition) { "profile::package {'linux-headers-generic': }" }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
