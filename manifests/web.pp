exec { "apt-update":
  command => "/usr/bin/apt-get update",
}

$deploymentapps = ['mysql-server','maven','git']

package { $deploymentapps:
  ensure  => installed,
  require => Exec["apt-update"],
}

service { 'mysql':
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package[$deploymentapps],
}

exec { "clone-petclinic":
  #unless  => "cd spring-framework-petclinic'",
  command => "sudo git clone https://github.com/spring-petclinic/spring-framework-petclinic",
  path    => ["/usr/bin", "/bin"],
  require => Package[$deploymentapps],
}

file { "/home/vagrant/spring-framework-petclinic/pom.xml":
  #owner   => "mvn",
  #mode    => "0644",
  content => template("/vagrant/manifests/pom.xml"),
  require => Exec["clone-petclinic"],
}

exec { "deploy":
  command => "sudo ./mvnw jetty:run-war -P MySQL",
  path    => ["/usr/bin", "/bin"],
  cwd     => "/home/vagrant/spring-framework-petclinic"
}

