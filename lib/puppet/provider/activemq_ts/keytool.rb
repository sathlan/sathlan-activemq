require 'tempfile'
require 'fileutils'

Puppet::Type.type(:activemq_ts).provide(:keytool) do
  commands :keytool => "keytool"

  def create
    # save md5 in a directory
    # TODO: how to retrieve the value Puppet[:vardir]
    puts "DEBUG-create1"
    md5_dir = File.join(Puppet[:vardir], 'activemq_store_md5')
    FileUtils.mkdir_p(md5_dir, :mode => 0700) unless File.directory?(md5_dir)
    puts "DEBUG-create: dir is #{md5_dir}"
    if resource[:private_key] and resource[:public_key]
      temp = Tempfile.new('pkcs')
      begin
        temp.puts(resource[:private_key].chomp)
        temp.puts(resource[:public_key].chomp)
        temp.rewind
        puts "DEBUG-create2: '#{temp.path}'"
        pkcs = `openssl pkcs12 -export -in #{temp.path} -password pass:#{resource[:password]} -name #{resource[:name]}`
        temp.rewind
        temp.puts(pkcs)
        temp.rewind
        keytool "-importkeystore", "-alias", resource[:alias], "-srcstorepass", resource[:password], "-destkeystore", resource[:keystore], "-srckeystore", temp.path, "-srcstoretype", "PKCS12", "-storepass" ,resource[:password], "-noprompt"
        temp.rewind
        temp.puts(resource[:public_key].chomp)
        temp.rewind
        `openssl x509 -in #{temp.path} -fingerprint -md5 | awk -F= '/MD5/{print $2}' > #{File.join(md5_dir, resource[:alias])}`
      ensure
        FileUtils.cp(temp.path, '/tmp/pkcs-0')
        temp.unlink
        temp.close
        # add into a catch
#        FileUtils.rm(File.join(md5_dir, resource[:alias])) if File.exists?(File.join(md5_dir, resource[:alias]))
      end
    else
      system("openssl x509 -in #{resource[:ca]} -fingerprint -md5 | awk -F= '/MD5/{print $2}'  > #{File.join(md5_dir, resource[:alias])}")
      keytool "-trustcacerts", "-import", "-alias", resource[:alias], "-file", resource[:ca], "-keystore", resource[:truststore], "-storepass", resource[:password], "-noprompt"
    end
  end

  def exists?
    md5_dir = File.join(Puppet[:vardir], 'activemq_store_md5')
    md5_file = File.join(md5_dir, resource[:alias])
    md5_given = false
    FileUtils.mkdir_p(md5_dir, :mode => 0700) unless File.directory?(md5_dir)
    puts "DEBUG-exists: dir is #{md5_dir}"
    if resource[:private_key] and resource[:public_key]
      keystore = resource[:keystore]
    else
      keystore = resource[:truststore]
    end
    puts "DEBUG-exists2"

    md5_in = `keytool -alias #{resource[:alias]} -list -keystore #{keystore} -storepass #{resource[:password]} -noprompt | awk -F': ' '/MD5/ {print $2}'`
    puts "DEBUG-exists3"
    md5_given = File.read(File.join(md5_dir, resource[:alias])).chomp if File.exists?(md5_file)
    puts "DEBUG-exists4 : got     #{md5_given and md5_given == md5_in.chomp} "
    md5_given and md5_given == md5_in.chomp
  end

  def destroy
    puts "DEBUG-destroy: dir is #{md5_dir}"
    md5_dir = File.join(Puppet[:vardir], 'activemq_store_md5')
    FileUtils.mkdir_p(md5_dir, :mode => 0700) unless File.directory?(md5_dir)
    keytool "-delete", "-alias", resource[:alias], "-storepass", resource[:password], "-noprompt"
    md5_file = File.join(md5_dir, resource[:alias])
    FileUtils.rm(md5_file) if File.exists?(md5_file)
  end
end
