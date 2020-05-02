require 'spec_helper'

describe 'profile::puppet::r10k', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        {
          github_secret: 'secret',
          control_repo: 'https://example.com',
          default_branch: 'develop',
        }
      end

      context 'compile' do
        it { is_expected.to contain_class('r10k') }
        it {
          is_expected.to contain_class('r10k::webhook::config').with(
            default_branch: 'develop',
            github_secret: 'secret',
          )
        }
        it { is_expected.to contain_class('r10k::webhook') }
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
