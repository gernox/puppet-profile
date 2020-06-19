require 'spec_helper'

describe 'profile::hardening', type: :class do
  let(:pre_condition) { "include '::profile'" }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

      describe 'not passing parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('profile::hardening::pam') }
        it { is_expected.to contain_class('profile::hardening::packages') }
        it { is_expected.to contain_class('profile::hardening::services') }
        it { is_expected.to contain_class('profile::hardening::securetty') }
        it { is_expected.to contain_class('profile::hardening::sysctl') }
        it { is_expected.to contain_class('profile::hardening::tcpwrappers') }
        it { is_expected.to contain_class('profile::hardening::network') }
      end

      describe 'passing manage parameter' do
        let(:params) { { manage: false } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('profile::hardening::pam') }
        it { is_expected.not_to contain_class('profile::hardening::packages') }
        it { is_expected.not_to contain_class('profile::hardening::services') }
        it { is_expected.not_to contain_class('profile::hardening::securetty') }
        it { is_expected.not_to contain_class('profile::hardening::sysctl') }
        it { is_expected.not_to contain_class('profile::hardening::tcpwrappers') }
        it { is_expected.not_to contain_class('profile::hardening::network') }
      end

      describe 'passing pam_class parameter' do
        let(:params) { { pam_class: '' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('profile::hardening::pam') }
      end

      describe 'passing packages_class parameter' do
        let(:params) { { packages_class: '' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('profile::hardening::packages') }
      end

      describe 'passing services_class parameter' do
        let(:params) { { services_class: '' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('profile::hardening::services') }
      end

      describe 'passing securetty_class parameter' do
        let(:params) { { securetty_class: '' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('profile::hardening::securetty') }
      end

      describe 'passing sysctl_class parameter' do
        let(:params) { { sysctl_class: '' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('profile::hardening::sysctl') }
      end

      describe 'passing tcpwrappers_class parameter' do
        let(:params) { { tcpwrappers_class: '' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('profile::hardening::tcpwrappers') }
      end

      describe 'passing network_class parameter' do
        let(:params) { { network_class: '' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('profile::hardening::network') }
      end
    end
  end
end
