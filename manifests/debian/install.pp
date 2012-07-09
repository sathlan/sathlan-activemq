class activemq::debian::install(){

  case $::lsbdistcodename {
    "squeeze": {
      package { 'openjdk-6-jre-headless':}
      class { 'apt::debian::testing': } # provided by stdlib
      apt::force { 'activemq':
        release => 'testing',
        version => '5.6.0+dfsg-1',
        require => [Class['Apt::Debian::Testing'], Package['openjdk-6-jre-headless']]
      }
    }

    default: {
      fail("Only squeeze is supported")
    }
  }
}
