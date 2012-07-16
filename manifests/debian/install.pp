class activemq::debian::install(){

  case $::lsbdistcodename {
    "squeeze": {
      # should go uptstream!
      file { '/etc/init.d/activemq':
        ensure => present,
        source => 'puppet:///activemq/etc/init.d/activemq',
        require => Apt::Force['activemq'],
      }
      package { 'openjdk-6-jre-headless':}
      apt::force { 'activemq':
        release => 'testing',
        version => '5.6.0+dfsg-1',
        require => Package['openjdk-6-jre-headless']
      }
    }

    default: {
      fail("Only squeeze is supported")
    }
  }
}
