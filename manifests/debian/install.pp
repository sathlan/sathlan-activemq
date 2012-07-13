class activemq::debian::install(){

  case $::lsbdistcodename {
    "squeeze": {
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
