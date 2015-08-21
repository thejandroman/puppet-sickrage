# == Class sickrage::params
#
# This class is meant to be called from sickrage.
# It sets variables according to platform.
#
class sickrage::params {
  # Install params
  $destination_file = '/srv/sickrage.tgz'
  $install_dir      = '/srv/sickrage'
  $manage_user      = true
  $pip_dependencies = { 'pyopenssl' => { ensure => '0.13.1'} }
  $pm_dependencies  = [ 'python-cheetah',
                        'unrar',
                        'python-pip',
                        'python-dev',
                        'libssl-dev',
                        'git' ]
  $source_url       = 'https://github.com/SiCKRAGETV/SickRage/archive/v4.0.53.tar.gz'
  $user             = 'sickrage'

  # Service params
  $service_enable = true
  $service_ensure = true

  case $::operatingsystem {
    'Ubuntu': {
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
