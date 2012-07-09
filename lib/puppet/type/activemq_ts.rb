Puppet::Type.newtype(:activemq_ts) do
  @doc = "Manage truststore for activemq"
  ensurable

  newparam(:ca) do
    desc "The path to certificate to trust in PEM format."
    validate do |path|
      unless File.exists?(path) and File.read("/var/lib/puppet/ssl/certs/ca.pem") =~
          /^-+BEGIN CERTIFICATE.*END CERTIFICATE-+.?$/m
        raise ArgumentError, "The path #{path} is not a valide certificate"
      end
    end
  end
  newparam(:private_key) do
    desc "The string representing the private key"
    validate do |pk|
      unless pk =~ /^-+BEGIN [^ ]+ PRIVATE KEY.*PRIVATE KEY-+.?$/m
        raise ArgumentError, "This doesn't look like a private key"
      end
    end
  end
  newparam(:public_key) do
    desc "The string representing the public key"
    validate do |pubk|
      unless pubk =~
          /^-+BEGIN CERTIFICATE.* CERTIFICATE-+.?$/m
        raise ArgumentError, "This doesn't look like a public key"
      end
    end

  end
  newparam(:keystore) do
    desc "The keystore file path"
    validate do |path|
      File.directory?(File.dirname(path))
    end
  end

  newparam(:alias) do
    desc "The name to give to the certificate"
    isnamevar
  end

  newparam(:truststore) do
    desc "The path to the trustore"
    validate do |path|
      File.directory?(File.dirname(path))
    end
  end
  newparam(:password) do
    desc "The password to the trustore"
    validate do |pass|
      raise ArgumentError, "The password must be more than 6 characters" unless path.length > 6
    end
  end
end
