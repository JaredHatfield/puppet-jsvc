# = Class: jsvc
#
# Manages JSVC.
#
#
class jsvc {
  package { 'apache-commons-daemon-jsvc':
    ensure => present,
  }
}
