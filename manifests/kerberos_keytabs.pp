# === Define: pulsevtm::kerberos_keytabs
#
# Kerberos Keytab
# A Kerberos keytab file contains credentials to authenticate as (a number of)
# Kerberos principals.
#
# === Parameters
#
# === Examples
#
# pulsevtm::kerberos_keytabs { 'example':
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
define pulsevtm::kerberos_keytabs (
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

  info ("Configuring kerberos_keytabs ${name}")
  vtmrest { "kerberos/keytabs/${name}":
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
    ensure_resource('file', "${purge_state_dir}/kerberos_keytabs", {ensure => present})
    file_line { "kerberos/keytabs/${name}":
      line => "kerberos/keytabs/${name}",
      path => "${purge_state_dir}/kerberos_keytabs",
    }
  }
}
