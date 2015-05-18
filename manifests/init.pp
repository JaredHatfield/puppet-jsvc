# = Class: apt
#
# Manages JSVC.
#
#
class jsvc {
  package { 'apache-commons-daemon-jsvc':
    ensure => present,
  }
}
