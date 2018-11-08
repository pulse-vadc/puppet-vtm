# === Define: pulsevtm::locations
#
# Location
# These are geographic locations as used by *Global Load Balancing* services.
# Such a location may not necessarily contain a traffic manager; instead it
# could refer to the location of a remote datacenter.
#
# === Parameters
#
# [*basic__id*]
# The identifier of this location.
#
# [*basic__latitude*]
# The latitude of this location.
#
# [*basic__longitude*]
# The longitude of this location.
#
# [*basic__note*]
# A note, used to describe this location.
#
# [*basic__type*]
# Does this location contain traffic managers and configuration or is it a
# recipient of GLB requests?
#
# === Examples
#
# pulsevtm::locations { 'example':
#     ensure => present,
#     basic__id => 8888
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
define pulsevtm::locations (
  $ensure,
  $basic__id,
  $basic__latitude  = 0.0,
  $basic__longitude = 0.0,
  $basic__note      = undef,
  $basic__type      = 'config',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring locations ${name}")
  vtmrest { "locations/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/locations.erb'),
    type     => 'application/json',
    internal => 'locations',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/locations", {ensure => present})
    file_line { "locations/${name}":
      line => "locations/${name}",
      path => "${purge_state_dir}/locations",
    }
  }
}
