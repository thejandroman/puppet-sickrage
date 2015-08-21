# == Class sickrage::install
#
# This class is called from sickrage for install.
#
class sickrage::install {

  package { $::sickrage::pm_dependencies:
    ensure => 'installed',
  }

  $pip_defaults = {
    ensure   => 'installed',
    provider => 'pip',
  }
  create_resources(package, $::sickrage::pip_dependencies, $pip_defaults)

  wget::fetch { 'sickrage download':
    source      => $::sickrage::source_url,
    destination => $::sickrage::destination_file,
  }

  file { $::sickrage::install_dir: ensure => 'directory', }

  exec { 'sickrage extract':
    command => "tar -xzf ${::sickrage::destination_file} --strip=1 \
    -C ${::sickrage::install_dir}",
    creates => "${::sickrage::install_dir}/SickBeard.py",
    path    => '/bin',
  }

  if $::sickrage::manage_user {
    user { $::sickrage::user:
      ensure     => present,
      comment    => 'Sickrage user',
      home       => $::sickrage::install_dir,
      managehome => false,
      system     => true,
    }

    File[$::sickrage::install_dir] { owner => $::sickrage::user, }
    Exec['sickrage extract'] { user => $::sickrage::user, }

    User[$::sickrage::user] -> File[$::sickrage::install_dir]
    User[$::sickrage::user] -> Exec['sickrage extract']
  }

  Package[$::sickrage::pm_dependencies] -> Package<| provider == 'pip' |>
  Wget::Fetch['sickrage download'] -> Exec['sickrage extract']
  File[$::sickrage::install_dir] -> Exec['sickrage extract']
}
