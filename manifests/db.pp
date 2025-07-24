exec { "apt-update":
  command => "/usr/bin/apt-get update",
}

package { "mysql-server":
  ensure  => installed,
  require => Exec["apt-update"],
}

file { "/etc/mysql/mysql.conf.d/mysqld.cnf":
  owner   => "mysql",
  group   => "mysql",
  mode    => "0644",
  content => template("/vagrant/manifests/allow_ext.cnf"),
  require => Package["mysql-server"],
  notify  => Service["mysql"],
}

service { "mysql":
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package["mysql-server"],
}

exec { "petclinic":
  unless  => "mysql -u root -e 'USE petclinic;'",
  command => "mysqladmin -u root create petclinic",
  path    => ["/usr/bin", "/bin"],
  require => Service["mysql"],
}

exec { "remove-anonymous-user":
  command => "mysql -u root -e \"DELETE FROM mysql.user WHERE user=''; FLUSH PRIVILEGES;\"",
  unless  => "mysql -u root -e \"SELECT User FROM mysql.user WHERE User='';\" | grep -v 'User'",
  path    => ["/usr/bin", "/bin"],
  require => Service["mysql"],
}

exec { "clinic-user":
  unless  => "mysql -u root -e \"SELECT User, Db FROM mysql.db WHERE User='cluser' AND Db='petclinic';\" | grep cluser",
  command => "mysql -u root -e \"CREATE USER 'cluser'@'%' IDENTIFIED BY 'petsecret'; GRANT ALL PRIVILEGES ON petclinic.* TO 'cluser'@'%';\"",
  path    => ["/usr/bin", "/bin"],
  require => Exec['petclinic'],
}
