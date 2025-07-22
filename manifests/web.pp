exec { "apt-update":
  command => "/usr/bin/apt-get update",
}

$deploymentapps = ['mysql-server','tomcat9','maven','git']

package { $deploymentapps:
  ensure  => installed,
  require => Exec["apt-update"],
}

$deploymentservices = ['mysql','tomcat9']

service { $deploymentservices:
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package[$deploymentapps],
}
