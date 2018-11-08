# === Define: pulsevtm::aptimizer_scopes
#
# Aptimizer Application Scope
# Application scopes define criteria that match URLs to specific logical web
# applications hosted by a virtual server.
#
# === Parameters
#
# [*basic__canonical_hostname*]
# If the hostnames for this scope are aliases of each other, the canonical
# hostname will be used for requests to the server.
#
# [*basic__hostnames*]
# The hostnames to limit acceleration to.
# Type:array
# Properties:
#
# [*basic__root*]
# The root path of the application defined by this application scope.
#
# === Examples
#
# pulsevtm::aptimizer_scopes { 'example':
#     ensure => present,
# }
#
#
# === Authors
#
#  Pulse Secure <puppet-vadc@pulsesecure.net>
#
# === Copyright
#
# Copyright 2018 Pulse Secure
#
define pulsevtm::aptimizer_scopes (
  $ensure,
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

  info ("Configuring aptimizer_scopes ${name}")
  vtmrest { "aptimizer/scopes/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/aptimizer_scopes.erb'),
    type     => 'application/json',
    internal => 'aptimizer_scopes',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/aptimizer_scopes", {ensure => present})
    file_line { "aptimizer/scopes/${name}":
      line => "aptimizer/scopes/${name}",
      path => "${purge_state_dir}/aptimizer_scopes",
    }
  }
}
