require 'spec_helper'

describe 'activemq::instance' do
  context 'on Debian' do
    let(:title)      { 'mcollective' }
    let(:facts)      { {:operatingsystem => 'Debian'} }
    let(:active_dir) { '/etc/activemq/instances-enabled' }
    let(:basedir)    { '/etc/activemq/instances-available/mcollective' }

    context 'activated instance' do
      puts "DDD: #{@basedir}"
      it { should contain_file("#{basedir}/activemq.xml").with_tag('activemq_mcollective_conf_on') }
      it { should contain_file("#{active_dir}/mcollective").with_ensure('link')}
    end

    context 'deactivated instance' do
      let(:params) { {:activate => false} }
      it { should contain_file("#{basedir}/activemq.xml").with_tag('activemq_mcollective_conf_off') }
      it { should contain_file("#{active_dir}/mcollective").with_ensure('absent')}
    end
  end
end
