require 'spec_helper'

describe 'profile::resilio::install', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        let(:params) do
          {
            device_name: 'data',
            listening_port: 8080,
            storage_path: '/storage',
            download_limit: 0,
            upload_limit: 0,
            directory_root: '/data',
            webui_listen_host: 'localhost',
            webui_listen_port: 4711,
            webui_user: 'user',
            webui_password: 'pwd',
          }
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
