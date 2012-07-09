class activemq(
  
  ) inherits activemq::params {
  anchor { 'activemq::begin': } # require stdlib (bug #8040)
  ->
  class { 'activemq::config':  }
  ->
  class { 'activemq::install': }
  ->
  class { 'activemq::service': }
  ->
  anchor { 'activemq::end': }
}
