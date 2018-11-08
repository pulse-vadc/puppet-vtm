# === Define: pulsevtm::rate
#
# Rate Shaping Class
# A rate shaping class restricts the number of connections being processed by
# a virtual server at once.
#
# === Parameters
#
# [*basic__max_rate_per_minute*]
# Requests that are associated with this rate class will be rate-shaped to
# this many requests per minute, set to "0" to disable the limit.
#
# [*basic__max_rate_per_second*]
# Although requests will be rate-shaped to the "max_rate_per_minute", the
# traffic manager will also rate limit per-second. This smooths traffic so
# that a full minute's traffic will not be serviced in the first second of the
# minute, set this to "0" to disable the per-second limit.
#
# [*basic__note*]
# A description of the rate class.
#
# === Examples
#
# pulsevtm::rate { 'example':
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
define pulsevtm::rate (
  $ensure,
  $basic__max_rate_per_minute = 0,
  $basic__max_rate_per_second = 0,
  $basic__note                = undef,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring rate ${name}")
  vtmrest { "rate/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/rate.erb'),
    type     => 'application/json',
    internal => 'rate',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/rate", {ensure => present})
    file_line { "rate/${name}":
      line => "rate/${name}",
      path => "${purge_state_dir}/rate",
    }
  }
}
