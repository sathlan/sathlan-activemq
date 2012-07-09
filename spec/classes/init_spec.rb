require 'spec_helper'

describe 'activemq' do
  context "#wheezy" do
    let(:facts) { {:operatingsystem => 'Debian', :lsbdistcodename => "squeeze"}}

    it {should include_class('activemq')}
    it {should include_class('activemq::install')}
    it {should include_class('activemq::debian::install')}
    it {should include_class('activemq::config')}
    it {should include_class('activemq::params')}
    it {should include_class('activemq::service')}
    it {should contain_package('openjdk-6-jre-headless')}
    it {should contain_apt__force('activemq').with_version('5.6.0+dfsg-1')}
  end

  context "#other" do
    let(:facts) { {:operatingsystem => 'Debian', :lsbdistcodename => "wheezy"}}

    it { expect { should include_class('activemq') }.
      to raise_error(Puppet::Error, /Only .* is supported/) }
  end
end
