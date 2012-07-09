define activemq::instance(
  $module_conf_tmpl  = 'activemq/activemq.xml',
  $module_params     = 'UNDEF',
  $module_log4j_tmpl = 'activemq/log4jproperties.erb',
  $module_cred_tmpl  = 'activemq/credentials.properties.erb',
  $activate          = true
  ) {

  if $::operatingsystem != 'Debian' {
    fail("Only Debian style configuration are supported")
  }
  $basedir = "/etc/activemq/instances-available/$name"
  file { "$basedir":
    ensure => directory,
  }
  if $module_params != 'UNDEF' {
    include "$module_params"
  }
  if $activate {
    $tagging = "activemq_${name}_conf_on"
  } else {
    $tagging = "activemq_${name}_conf_off"
  }
  file { "$basedir/activemq.xml":
    content => template($module_conf_tmpl),
    ensure  => present,
    tag     => $tagging,
    require => File["$basedir"]
  }

  file { "$basedir/log4j.properties":
    content => template($module_log4j_tmpl),
    ensure  => present,
    tag     => $tagging,
    require => File["$basedir"],
  }

  if $activate {
    $active_ensure = link
  } else {
    $active_ensure = absent
  }
  $active_basedir = '/etc/activemq/instances-enabled'
  file { "$active_basedir/$name":
    ensure => $active_ensure,
    target => "$basedir",
  }
  $activemq_var_base = "/var/lib/activemq/$name"
  
  file { "$activemq_var_base":
    ensure => directory,
  }
  file { "$activemq_var_base/conf":
    ensure => directory,
    require => File["$activemq_var_base"]
  }  
  file { "$activemq_var_base/conf/credentials.properties":
    ensure => present,
    tag    => $tagging,
    content => template($module_cred_tmpl),
    require => File["$activemq_var_base/conf"]
  }
  notify {"Checking status for $name":}
  if $activate {
    service { "activemq_${name}":
      ensure    => running,
      hasstatus => false,
      status    => "/etc/init.d/activemq status ${name} | grep -vq '${name}.*stopped'",
      start     => "/etc/init.d/activemq start-server ${name}",
      stop      => "/etc/init.d/activemq stop-server ${name}",
    }
  }
  Service["activemq_${name}"] <~ File <|tag == 'activemq_${name}_conf_on'|>
}
