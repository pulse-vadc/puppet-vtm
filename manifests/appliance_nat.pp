# === class: pulsevtm::appliance_nat
#
# NAT Configuration
# The NAT configuration file stores rules controlling NAT on an appliance.
#
# === Parameters
#
# [*basic__many_to_one_all_ports*]
# This is table 'many_to_one_all_ports'
# Type:array
# Properties:{"rule_number"=>{"description"=>"A unique rule identifier",
# "type"=>"string"}, "pool"=>{"description"=>"Pool of a \"many to one
# overload\" type NAT rule.", "type"=>"string"}, "tip"=>{"description"=>"TIP
# Group of a \"many to one overload\" type NAT rule.", "type"=>"string"}}
#
# [*basic__many_to_one_port_locked*]
# This is table 'many_to_one_port_locked'
# Type:array
# Properties:{"rule_number"=>{"description"=>"A unique rule identifier",
# "type"=>"string"}, "pool"=>{"description"=>"Pool of a \"many to one port
# locked\" type NAT rule.", "type"=>"string"}, "port"=>{"description"=>"Port
# number of a \"many to one port locked\" type NAT rule.", "type"=>"integer",
# "minimum"=>1, "maximum"=>65535}, "protocol"=>{"description"=>"Protocol of a
# \"many to one port locked\" type NAT rule.", "type"=>"string",
# "enum"=>["icmp", "sctp", "tcp", "udp", "udplite"]},
# "tip"=>{"description"=>"TIP Group of a \"many to one port locked\" type NAT
# rule.", "type"=>"string"}}
#
# [*basic__one_to_one*]
# This is table 'one_to_one'
# Type:array
# Properties:{"rule_number"=>{"description"=>"A unique rule identifier",
# "type"=>"string"}, "enable_inbound"=>{"description"=>"Enabling the inbound
# part of a \"one to one\" type NAT rule.", "type"=>"boolean"},
# "ip"=>{"description"=>"IP Address of a \"one to one\" type NAT rule.",
# "type"=>"string"}, "tip"=>{"description"=>"TIP group of a \"one to one\"
# type NAT rule.", "type"=>"string"}}
#
# [*basic__port_mapping*]
# This is table 'port_mapping'
# Type:array
# Properties:{"rule_number"=>{"description"=>"A unique rule identifier",
# "type"=>"string"}, "dport_first"=>{"description"=>"First port of the dest.
# port range of a \"port mapping\" rule.", "type"=>"integer", "minimum"=>1,
# "maximum"=>65535}, "dport_last"=>{"description"=>"Last port of the dest.
# port range of a \"port mapping\" rule.", "type"=>"integer", "minimum"=>1,
# "maximum"=>65535}, "virtual_server"=>{"description"=>"Target Virtual Server
# of a \"port mapping\" rule.", "type"=>"string"}}
#
# === Examples
#
# class {'pulsevtm::appliance_nat':
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
class pulsevtm::appliance_nat (
  $ensure                         = present,
  $basic__many_to_one_all_ports   = '[]',
  $basic__many_to_one_port_locked = '[]',
  $basic__one_to_one              = '[]',
  $basic__port_mapping            = '[]',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring appliance_nat ${name}")
  vtmrest { 'appliance/nat':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/appliance_nat.erb'),
    type     => 'application/json',
    internal => 'appliance_nat',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/appliance", {ensure => present})
    file_line { 'appliance/nat':
      line => 'appliance/nat',
      path => "${purge_state_dir}/appliance",
    }
  }
}
