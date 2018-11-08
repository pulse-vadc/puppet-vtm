# === Define: pulsevtm::ssl_cas
#
# SSL Trusted Certificate
# SSL certificate authority certificates (CAs) and certificate revocation
# lists (CRLs) can be used when validating server and client certificates.
#
# === Parameters
#
# === Examples
#
# pulsevtm::ssl_cas { 'example':
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
define pulsevtm::ssl_cas (
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

  info ("Configuring ssl_cas ${name}")
  vtmrest { "ssl/cas/${name}":
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
    ensure_resource('file', "${purge_state_dir}/ssl_cas", {ensure => present})
    file_line { "ssl/cas/${name}":
      line => "ssl/cas/${name}",
      path => "${purge_state_dir}/ssl_cas",
    }
  }
}
