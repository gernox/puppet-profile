require 'spec_helper'

describe 'profile::php', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          version: '7.0'
        }
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
