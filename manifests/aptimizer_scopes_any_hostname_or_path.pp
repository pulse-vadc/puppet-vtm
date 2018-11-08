# === class: pulsevtm::aptimizer_scopes_any_hostname_or_path
#
# This class is a direct implementation of brocadvtm::aptimizer_scopes
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::aptimizer_scopes_any_hostname_or_path (
  $ensure                    = present,
  $basic__canonical_hostname = undef,
  $basic__hostnames          = '[]',
  $basic__root               = '/',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring aptimizer_scopes_any_hostname_or_path ${name}")
  vtmrest { 'aptimizer/scopes/Any%20hostname%20or%20path':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/aptimizer_scopes.erb'),
    type     => 'application/json',
    internal => 'aptimizer_scopes_any_hostname_or_path',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/aptimizer_scopes", {ensure => present})
    file_line { 'aptimizer/scopes/Any%20hostname%20or%20path':
      line => 'aptimizer/scopes/Any%20hostname%20or%20path',
      path => "${purge_state_dir}/aptimizer_scopes",
    }
  }
}
