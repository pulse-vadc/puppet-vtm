# === Define: pulsevtm::kerberos_krb5confs
#
# Kerberos Configuration File
# A Kerberos krb5.conf file that provides the raw configuration for a Kerberos
# principal.
#
# === Parameters
#
# === Examples
#
# pulsevtm::kerberos_krb5confs { 'example':
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
define pulsevtm::kerberos_krb5confs (
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

  info ("Configuring kerberos_krb5confs ${name}")
  vtmrest { "kerberos/krb5confs/${name}":
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
    ensure_resource('file', "${purge_state_dir}/kerberos_krb5confs", {ensure => present})
    file_line { "kerberos/krb5confs/${name}":
      line => "kerberos/krb5confs/${name}",
      path => "${purge_state_dir}/kerberos_krb5confs",
    }
  }
}
