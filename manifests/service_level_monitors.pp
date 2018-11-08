# === Define: pulsevtm::service_level_monitors
#
# SLM Class
# Service level monitoring is used to produce alerts when an application's
# performance is degraded. This is done by monitoring the response time of
# connections to a virtual server.
#
# === Parameters
#
# [*basic__note*]
# A description for the SLM class.
#
# [*basic__response_time*]
# Responses that arrive within this time limit, expressed in milliseconds, are
# treated as conforming.
#
# [*basic__serious_threshold*]
# When the percentage of conforming responses drops below this level, a
# serious error level message will be emitted.
#
# [*basic__warning_threshold*]
# When the percentage of conforming responses drops below this level, a
# warning message will be emitted.
#
# === Examples
#
# pulsevtm::service_level_monitors { 'example':
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
define pulsevtm::service_level_monitors (
  $ensure,
  $basic__note              = undef,
  $basic__response_time     = 1000,
  $basic__serious_threshold = 0,
  $basic__warning_threshold = 50,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring service_level_monitors ${name}")
  vtmrest { "service_level_monitors/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/service_level_monitors.erb'),
    type     => 'application/json',
    internal => 'service_level_monitors',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/service_level_monitors", {ensure => present})
    file_line { "service_level_monitors/${name}":
      line => "service_level_monitors/${name}",
      path => "${purge_state_dir}/service_level_monitors",
    }
  }
}
