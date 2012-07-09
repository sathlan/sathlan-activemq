dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, '../lib/facter')


require 'rspec-puppet'
require 'tmpdir'
require 'puppet'
require 'facter'
#require 'facter/util/confine'

def param_value(subject, type, title, param)
  subject.resource(type, title).send(:parameters)[param.to_sym]
end

RSpec.configure do |c|
  c.before :each do

    # Create a temporary puppet confdir area and temporary site.pp so
    # when rspec-puppet runs we don't get a puppet error.
    # from : http://projects.puppetlabs.com/issues/11191
    @puppetdir = Dir.mktmpdir("buildbot")
    manifestdir = File.join(@puppetdir, "manifests")
    Dir.mkdir(manifestdir)
    FileUtils.touch(File.join(manifestdir, "site.pp"))
    Puppet[:confdir] = @puppetdir
  end
  c.after :each do
    FileUtils.remove_entry_secure(@puppetdir)
  end
  c.mock_with :mocha
  c.module_path = File.join(File.dirname(__FILE__), '../../')
#  c.manifest_dir = '../manifests'
#  c.manifest = 'init.pp'
end

#
#
## We need this because the RAL uses 'should' as a method.  This
## allows us the same behaviour but with a different method name.
#class Object
#    alias :must :should
#end
