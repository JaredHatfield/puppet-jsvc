
define jsvc::deamon(
  $jsvc_name,
  $jsvc_class_path,
  $jsvc_class,
  $jsvc_java_home,
  $ensure = true,
  $jsvc_exec = "/usr/bin/jsvc") {

  group { $jsvc_name:
    ensure => present,
  }

  user { $jsvc_name:
    ensure  => present,
    comment => "${jsvc_name} JSVC Deamon",
    gid     => $jsvc_name,
    home    => "/var/lib/${jsvc_name}/",
    shell   => "/sbin/nologin",
    require => File["/var/lib/${jsvc_name}/"],
  }

  file { "/var/lib/${jsvc_name}/":
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => 664,
    }

  file { "/var/log/${jsvc_name}/":
    ensure => directory,
    owner  => $jsvc_name,
    group  => $jsvc_name,
    mode   => 664,
  }

  file { "/etc/${jsvc_name}/":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 664,
  }

  file { "/etc/${jsvc_name}/log4j.properties":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("jsvc/log4j.properties.erb"),
    require => [File["/etc/${jsvc_name}/"]],
    notify  => Service[$jsvc_name],
  }

  file { "/etc/init.d/${jsvc_name}":
    owner   => root,
    group   => root,
    mode    => 755,
    content => template("jsvc/deamon.erb"),
    require => [File["/var/log/${jsvc_name}/"], File["/etc/${jsvc_name}/log4j.properties"]],
    notify  => Service[$jsvc_name],
  }

  service { $jsvc_name:
    ensure  => $ensure,
    require => File["/etc/init.d/${jsvc_name}"],
  }
}
