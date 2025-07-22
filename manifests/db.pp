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

exec { "loja-schema":
  unless  => "mysql -u root -e 'USE loja_schema;'",
  command => "mysqladmin -u root create loja_schema",
  path    => ["/usr/bin", "/bin"],
  require => Service["mysql"],
}

exec { "remove-anonymous-user":
  command => "mysql -u root -e \"DELETE FROM mysql.user WHERE user=''; FLUSH PRIVILEGES;\"",
  unless  => "mysql -u root -e \"SELECT User FROM mysql.user WHERE User='';\" | grep -v 'User'",
  path    => ["/usr/bin", "/bin"],
  require => Service["mysql"],
}

exec { "loja-user":
  unless  => "mysql -u root -e \"SELECT User, Db FROM mysql.db WHERE User='loja' AND Db='loja_schema';\" | grep loja",
  command => "mysql -u root -e \"CREATE USER 'loja'@'%' IDENTIFIED BY 'lojasecret'; GRANT ALL PRIVILEGES ON loja_schema.* TO 'loja'@'%';\"",
  path    => ["/usr/bin", "/bin"],
  require => Exec['loja-schema'],
}
