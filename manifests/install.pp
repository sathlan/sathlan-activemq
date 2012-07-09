class activemq::install(){
  $worker = downcase("activemq::${::operatingsystem}::install")
  class {"$worker":}
}
