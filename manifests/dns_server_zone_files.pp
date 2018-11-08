# === Define: pulsevtm::dns_server_zone_files
#
# DNS Zone File
# The "conf/dnsserver/zonefiles/" directory contains files that define DNS
# zones.
#
# === Parameters
#
# === Examples
#
# pulsevtm::dns_server_zone_files { 'example':
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
define pulsevtm::dns_server_zone_files (
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

  info ("Configuring dns_server_zone_files ${name}")
  vtmrest { "dns_server/zone_files/${name}":
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
    ensure_resource('file', "${purge_state_dir}/dns_server_zone_files", {ensure => present})
    file_line { "dns_server/zone_files/${name}":
      line => "dns_server/zone_files/${name}",
      path => "${purge_state_dir}/dns_server_zone_files",
    }
  }
}
