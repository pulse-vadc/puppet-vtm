# === Define: pulsevtm::action_programs
#
# Action Program
# This is a program or script that can be referenced and used by actions of
# type 'Program'
#
# === Parameters
#
# === Examples
#
# pulsevtm::action_programs { 'example':
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
define pulsevtm::action_programs (
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

  info ("Configuring action_programs ${name}")
  vtmrest { "action_programs/${name}":
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
    ensure_resource('file', "${purge_state_dir}/action_programs", {ensure => present})
    file_line { "action_programs/${name}":
      line => "action_programs/${name}",
      path => "${purge_state_dir}/action_programs",
    }
  }
}
