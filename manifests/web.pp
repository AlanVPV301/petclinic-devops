#exec { "apt-update":
#  command => "/usr/bin/apt-get update",
#}

$deploymentapps = ['mysql-server','maven','git','openjdk-17-jdk']

package { $deploymentapps:
  ensure  => installed,
 # require => Exec["apt-update"],
}

service { 'mysql':
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package[$deploymentapps],
}

exec { "clone-petclinic":
  command => "sudo git clone https://github.com/spring-petclinic/spring-framework-petclinic",
  path    => ["/usr/bin", "/bin"],
  creates => "/home/vagrant/spring-framework-petclinic",
  require => Package[$deploymentapps],

}

file { "/home/vagrant/spring-framework-petclinic/pom.xml":
  content => template("/vagrant/manifests/pom.xml"),
  require => Exec["clone-petclinic"],
}

exec { "deploy":
  command     => "nohup sudo ./mvnw jetty:run-war -P MySQL >/dev/null 2>&1 &",
  path        => ["/usr/bin", "/bin", "/usr/sbin"],
  cwd         => "/home/vagrant/spring-framework-petclinic",
  unless  => "curl 192.168.56.12:8080", 
  require     => File['/home/vagrant/spring-framework-petclinic/pom.xml'],
  timeout => 0
}

exec { "health-check" :
  command    => "curl -s -f http://192.168.56.12:8080",
  path       => ["/usr/bin", "/bin"],
  try_sleep  => 60,
  tries      => 5,
  unless     => "curl -s -f http://192.168.56.12:8080",
  require    => Exec["deploy"]
}

