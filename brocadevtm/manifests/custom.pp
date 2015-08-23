# === Define: brocadevtm::custom
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
# brocadevtm::custom { 'example':
#     ensure => present,
# }
#
#
# === Authors
#
# Mark Boddington <mbodding@brocade>
#
# === Copyright
#
# Copyright 2015 Brocade
#
define brocadevtm::custom (
  $ensure,
  $basic__string_lists = '[]',
){
  include brocadevtm
  $ip      = $brocadevtm::rest_ip
  $port    = $brocadevtm::rest_port
  $user    = $brocadevtm::rest_user
  $pass    = $brocadevtm::rest_pass

  info ("Configuring custom ${name}")
  vtmrest { "custom/${name}":
    ensure     => $ensure,
    endpoint   => "https://${ip}:${port}/api/tm/3.3/config/active",
    username   => $user,
    password   => $pass,
    content    => template('brocadevtm/custom.erb'),
    type       => 'application/json',
    internal   => 'custom',
    debug      => 0,
  }
}
