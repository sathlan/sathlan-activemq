class activemq::install(){
  $worker = downcase("activemq::${::operatingsystem}::install")
  anchor { 'activemq::install::begin': }
  ->
  class {"$worker":}
  ->
  anchor { 'activemq::install::end':}
}
