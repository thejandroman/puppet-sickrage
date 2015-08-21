# Class: sickrage
# ===========================
#
# Full description of class sickrage here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sickrage (
  # Install params
  $pm_dependencies  = $::sickrage::params::pm_dependencies,
  $pip_dependencies = $::sickrage::params::pip_dependencies,
  $destination_file = $::sickrage::params::destination_file,
  $install_dir      = $::sickrage::params::install_dir,
  $manage_user      = $::sickrage::params::manage_user,
  $source_url       = $::sickrage::params::source_url,
  $user             = $::sickrage::params::user,

  # Service params
  $service_ensure = $::sickrage::params::service_ensure,
  $service_enable = $::sickrage::params::service_enable,
  ) inherits ::sickrage::params {

  # Install params
  validate_absolute_path($destination_file, $install_dir)
  validate_array($pm_dependencies)
  validate_bool($manage_user)
  validate_hash($pip_dependencies)
  validate_string($source_url, $user)

  # Service params
  validate_bool($service_enable, $service_ensure)

  class { '::sickrage::install': } ->
  class { '::sickrage::service': } ->
  Class['::sickrage']
}
