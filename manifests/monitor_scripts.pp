# === Define: pulsevtm::monitor_scripts
#
# Monitor Program
# An executable program that can be used to by external program monitors to
# report the health of backend services.
#
# === Parameters
#
# === Examples
#
# pulsevtm::monitor_scripts { 'example':
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
define pulsevtm::monitor_scripts (
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

  info ("Configuring monitor_scripts ${name}")
  vtmrest { "monitor_scripts/${name}":
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
    ensure_resource('file', "${purge_state_dir}/monitor_scripts", {ensure => present})
    file_line { "monitor_scripts/${name}":
      line => "monitor_scripts/${name}",
      path => "${purge_state_dir}/monitor_scripts",
    }
  }
}
