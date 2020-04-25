require 'spec_helper'

describe 'profile::puppet::puppetdb', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to contain_class('puppetdb') }
        it { is_expected.to contain_class('puppetdb::master::config') }
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
