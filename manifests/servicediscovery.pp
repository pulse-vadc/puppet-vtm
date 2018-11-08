# === Define: pulsevtm::servicediscovery
#
# Service Discovery Plugins
# The "conf/servicediscovery" directory contains plugins for use with Service
# Discovery for pool nodes.
#
# === Parameters
#
# === Examples
#
# pulsevtm::servicediscovery { 'example':
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
define pulsevtm::servicediscovery (
  $ensure,
  $content,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring servicediscovery ${name}")
  vtmrest { "servicediscovery/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => $content,
    type     => 'application/octet-stream',
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/servicediscovery", {ensure => present})
    file_line { "servicediscovery/${name}":
      line => "servicediscovery/${name}",
      path => "${purge_state_dir}/servicediscovery",
    }
  }
}
