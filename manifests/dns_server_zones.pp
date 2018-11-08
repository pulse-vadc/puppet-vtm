# === Define: pulsevtm::dns_server_zones
#
# DNS Zone
# The "conf/dnsserver/zones/" file contains zone metadata
#
# === Parameters
#
# [*basic__origin*]
# The domain origin of this Zone.
#
# [*basic__zonefile*]
# The Zone File encapsulated by this Zone.
#
# === Examples
#
# pulsevtm::dns_server_zones { 'example':
#     ensure => present,
#     basic__origin => 'foo'
#     basic__zonefile => 'foo'
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
define pulsevtm::dns_server_zones (
  $ensure,
  $basic__origin,
  $basic__zonefile,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring dns_server_zones ${name}")
  vtmrest { "dns_server/zones/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/dns_server_zones.erb'),
    type     => 'application/json',
    internal => 'dns_server_zones',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/dns_server_zones", {ensure => present})
    file_line { "dns_server/zones/${name}":
      line => "dns_server/zones/${name}",
      path => "${purge_state_dir}/dns_server_zones",
    }
  }
}
