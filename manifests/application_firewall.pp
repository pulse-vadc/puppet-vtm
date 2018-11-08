# === class: pulsevtm::application_firewall
#
# Pulse Secure Virtual Web Application Firewall
# The "conf/zeusafm.conf" file contains configuration files for the
# application firewall. Some keys present in the "zeusafm.conf" are not
# documented here. Refer to the Pulse Secure Web Application Firewall
# documentation for further details. The configuration can be edited under the
# "System > Application Firewall" section of the Administration Server or by
# using functions under the "AFM" section of the SOAP API and CLI.
#
# === Parameters
#
# === Examples
#
# class {'pulsevtm::application_firewall':
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
class pulsevtm::application_firewall (
  $ensure  = present,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring application_firewall ${name}")
  vtmrest { 'application_firewall':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/application_firewall.erb'),
    type     => 'application/json',
    internal => 'application_firewall',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/application_firewall", {ensure => present})
    file_line { 'application_firewall':
      line => 'application_firewall',
      path => "${purge_state_dir}/application_firewall",
    }
  }
}
