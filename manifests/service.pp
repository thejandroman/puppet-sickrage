# == Class sickrage::service
#
# This class is meant to be called from sickrage.
# It ensure the service is running.
#
class sickrage::service {

  file { '/etc/default/sickrage':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('sickrage/sickrage.defaults.erb'),
  }

  file { '/etc/init/sickrage.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('sickrage/sickrage.upstart.erb'),
  }

  service { 'sickrage':
    ensure     => $::sickrage::service_ensure,
    enable     => $::sickrage::service_enable,
    hasrestart => true,
    hasstatus  => true,
    provider   => 'upstart',
  }

  File['/etc/default/sickrage'] ~> Service['sickrage']
  File['/etc/init/sickrage.conf'] ~> Service['sickrage']
}
