require 'spec_helper'

describe 'profile::openvpn', type: :class do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          cipher: 'AES-256-CBC',
          tls_cipher: 'TLS-DHE-RSA-WITH-AES-256-GCM-SHA384',
          config_dir: '/etc/openvpn',
          user: 'openvpn_server',
          network: '10.200.200.0 255.255.255.0',
          network_ipv6: 'fe80:1337:1337:1337::/64',
          routes: ['192.168.30.0 255.255.255.0', '192.168.35.0 255.255.0.0'],
          routes_ipv6: ['2001:db8:1234::/64', '2001:db8:abcd::/64'],
          country: 'CO',
          province: 'ST',
          city: 'Some City',
          organization: 'example.org',
          email: 'testemail@example.org',
        }
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
