# === Define: pulsevtm::custom
#
# Custom configuration set
# Custom configuration sets store arbitrary named values. These values can be
# read by SOAP or REST clients.
#
# === Parameters
#
# [*basic__string_lists*]
# This table contains named lists of strings
# Type:array
# Properties:{"name"=>{"description"=>"Name of list", "type"=>"string"},
# "value"=>{"description"=>"Named list of user-specified strings.",
# "type"=>"array", "uniqueItems"=>false, "items"=>{"type"=>"string"}}}
#
# === Examples
#
# pulsevtm::custom { 'example':
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
define pulsevtm::custom (
  $ensure,
  $basic__string_lists = '[]',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring custom ${name}")
  vtmrest { "custom/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/custom.erb'),
    type     => 'application/json',
    internal => 'custom',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/custom", {ensure => present})
    file_line { "custom/${name}":
      line => "custom/${name}",
      path => "${purge_state_dir}/custom",
    }
  }
}
