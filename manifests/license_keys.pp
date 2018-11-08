# === Define: pulsevtm::license_keys
#
# License
# A license key is a encoded text file that controls what functionality is
# available from each traffic manager in the cluster. Every production traffic
# manager must have a valid licence key in order to function; a traffic
# manager without a license will operate in developer mode, allowing
# developers to trial a wide range of functionality, but placing restrictions
# on bandwidth.
#
# === Parameters
#
# === Examples
#
# pulsevtm::license_keys { 'example':
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
define pulsevtm::license_keys (
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

  info ("Configuring license_keys ${name}")
  vtmrest { "license_keys/${name}":
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
    ensure_resource('file', "${purge_state_dir}/license_keys", {ensure => present})
    file_line { "license_keys/${name}":
      line => "license_keys/${name}",
      path => "${purge_state_dir}/license_keys",
    }
  }
}
