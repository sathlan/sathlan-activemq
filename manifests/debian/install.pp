class activemq::debian::install(){

  case $::lsbdistcodename {
    "squeeze": {
      # should go uptstream!
      file { '/etc/init.d/activemq':
        ensure => present,
        source => 'puppet:///modules/activemq/etc/init.d/activemq',
        require => Apt::Force['activemq'],
      }
      package { 'openjdk-6-jre-headless':}
      apt::force { 'activemq':
        release => 'testing',
        version => '5.6.0+dfsg-1',
        timeout => 3600,
        require => Package['openjdk-6-jre-headless']
      }
      # activemq wheezy uid match one of squeeze, so it's not
      # installed.
      if !defined(User[activemq]) {
        user {'activemq':
          ensure => present,
          system => true,
        }
      }
    }

    default: {
      fail("Only squeeze is supported")
    }
  }
}
