require 'spec_helper'

describe 'profile::postgresql' do
  let(:pre_condition) { "include '::profile'" }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          version: '9.1',
          password: 'passwd',
          dbs: {},
        }
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
