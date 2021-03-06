require 'spec_helper'

describe 'profile::resilio' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        let(:params) do
          {
            webui_password: 'pwd',
          }
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
