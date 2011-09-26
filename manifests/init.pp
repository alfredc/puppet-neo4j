# Class: neo4j
#
# For installing neo4j server.
#
class neo4j {

  $release = "neo4j-community-1.5.M01"

  exec { 'neo4j-download':
    command => "wget -O /var/tmp/${release}-unix.tar.gz http://dist.neo4j.org/${release}-unix.tar.gz",
    creates => "/var/tmp/${release}-unix.tar.gz",
    path => ["/bin", "/usr/bin"],
  }
  
  exec { 'neo4j-extract':
    command => "tar -xzf /var/tmp/${release}-unix.tar.gz -C /opt",
    creates => "/opt/#{release}",
    path => ["/bin", "/usr/bin"],
    require => Exec['neo4j-download'],
  }
  
  exec { 'neo4j-install':
    command => "yes '' | /opt/${release}/bin/neo4j install",
    unless => "service neo4j-service status",
    require => Exec['neo4j-extract'],
    notify => Service['neo4j-service'],
  }
  
  service { 'neo4j-service':
    enable  => true,
    ensure  => running,
    hasrestart => true,
    require => Exec['neo4j-install'],
  }
}