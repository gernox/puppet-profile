require 'spec_helper'

describe 'profile::hardening::network', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('profile::hardening::network') }
      end

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to have_file_resource_count(0) }
      end
    end
  end
end
