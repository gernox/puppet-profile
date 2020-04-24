require 'spec_helper_acceptance'

describe 'foobar' do
  context 'when no parameter' do
    it do
      pp = <<-PUPPETCODE
      class { profile::foobar:
      }
      PUPPETCODE

      idempotent_apply(pp)

      expect(file('/etc/foobar')).to be_file
      expect(file('/etc/foobar')).to contain 'foobar??'
    end
  end
end
