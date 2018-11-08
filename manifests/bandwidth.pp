# === Define: pulsevtm::bandwidth
#
# Bandwidth Class
# A Bandwidth class, which can be assigned to a virtual server or pool in
# order to limit the number of bytes per second used by inbound or outbound
# traffic.
#
# === Parameters
#
# [*basic__maximum*]
# The maximum bandwidth to allocate to connections that are associated with
# this bandwidth class (in kbits/second).
#
# [*basic__note*]
# A description of this bandwidth class.
#
# [*basic__sharing*]
# The scope of the bandwidth class.
#
# === Examples
#
# pulsevtm::bandwidth { 'example':
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
define pulsevtm::bandwidth (
  $ensure,
  $basic__maximum = 10000,
  $basic__note    = undef,
  $basic__sharing = 'cluster',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring bandwidth ${name}")
  vtmrest { "bandwidth/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/bandwidth.erb'),
    type     => 'application/json',
    internal => 'bandwidth',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/bandwidth", {ensure => present})
    file_line { "bandwidth/${name}":
      line => "bandwidth/${name}",
      path => "${purge_state_dir}/bandwidth",
    }
  }
}
