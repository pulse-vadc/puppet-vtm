# === Define: pulsevtm::kerberos_principals
#
# Kerberos Principal
# A Kerberos principal can be used by the traffic manager to participate in a
# Kerberos realm.
#
# === Parameters
#
# [*basic__kdcs*]
# A list of "<hostname/ip>:<port>" pairs for Kerberos key distribution center
# (KDC) services to be explicitly used for the realm of the principal.  If no
# KDCs are explicitly configured, DNS will be used to discover the KDC(s) to
# use.
# Type:array
# Properties:
#
# [*basic__keytab*]
# The name of the Kerberos keytab file containing suitable credentials to
# authenticate as the specified Kerberos principal.
#
# [*basic__krb5conf*]
# The name of an optional Kerberos configuration file (krb5.conf).
#
# [*basic__realm*]
# The Kerberos realm where the principal belongs.
#
# [*basic__service*]
# The service name part of the Kerberos principal name the traffic manager
# should use to authenticate itself.
#
# === Examples
#
# pulsevtm::kerberos_principals { 'example':
#     ensure => present,
#     basic__keytab => 'foo'
#     basic__service => 'foo'
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
define pulsevtm::kerberos_principals (
  $ensure,
  $basic__keytab,
  $basic__service,
  $basic__kdcs     = '[]',
  $basic__krb5conf = undef,
  $basic__realm    = undef,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring kerberos_principals ${name}")
  vtmrest { "kerberos/principals/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/kerberos_principals.erb'),
    type     => 'application/json',
    internal => 'kerberos_principals',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/kerberos_principals", {ensure => present})
    file_line { "kerberos/principals/${name}":
      line => "kerberos/principals/${name}",
      path => "${purge_state_dir}/kerberos_principals",
    }
  }
}
