# === Define: pulsevtm::extra_files
#
# Extra File
# A user-uploaded file. Such files can be used in TrafficScript code using the
# "resource.get" function.
#
# === Parameters
#
# === Examples
#
# pulsevtm::extra_files { 'example':
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
define pulsevtm::extra_files (
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

  info ("Configuring extra_files ${name}")
  vtmrest { "extra_files/${name}":
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
    ensure_resource('file', "${purge_state_dir}/extra_files", {ensure => present})
    file_line { "extra_files/${name}":
      line => "extra_files/${name}",
      path => "${purge_state_dir}/extra_files",
    }
  }
}
