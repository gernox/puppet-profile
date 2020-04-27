require 'spec_helper'

describe 'profile::puppet::agent', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(serverversion: '6.10.0')
      end

      context 'compile' do
        it { is_expected.to contain_class('puppet_agent') }
        it { is_expected.to contain_file('/etc/apt/sources.list.d/puppet6.list').with(
          ensure: 'absent'
        ) }
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
