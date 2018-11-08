# === Define: pulsevtm::persistence
#
# Session Persistence Class
# A session persistence class is used to identify the session a new connection
# belongs too and deliver it to the same backend node.
#
# === Parameters
#
# [*basic__cookie*]
# The cookie name to use for tracking session persistence.
#
# [*basic__delete*]
# Whether or not the session should be deleted when a session failure occurs.
# (Note, setting a failure mode of 'choose a new node' implicitly deletes the
# session.)
#
# [*basic__failure_mode*]
# The action the pool should take if the session data is invalid or it cannot
# contact the node specified by the session.
#
# [*basic__note*]
# A description of the session persistence class.
#
# [*basic__subnet_prefix_length_v4*]
# When using IP-based session persistence, ensure all requests from this IPv4
# subnet, specified as a prefix length, are sent to the same node. If set to
# 0, requests from different IPv4 addresses will be load-balanced individually.
#
# [*basic__subnet_prefix_length_v6*]
# When using IP-based session persistence, ensure all requests from this IPv6
# subnet, specified as a prefix length, are sent to the same node. If set to
# 0, requests from different IPv6 addresses will be load-balanced individually.
#
# [*basic__type*]
# The type of session persistence to use.
#
# [*basic__url*]
# The redirect URL to send clients to if the session persistence is configured
# to redirect users when a node dies.
#
# === Examples
#
# pulsevtm::persistence { 'example':
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
define pulsevtm::persistence (
  $ensure,
  $basic__cookie                  = undef,
  $basic__delete                  = true,
  $basic__failure_mode            = 'new_node',
  $basic__note                    = undef,
  $basic__subnet_prefix_length_v4 = 0,
  $basic__subnet_prefix_length_v6 = 0,
  $basic__type                    = 'ip',
  $basic__url                     = undef,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring persistence ${name}")
  vtmrest { "persistence/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/persistence.erb'),
    type     => 'application/json',
    internal => 'persistence',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/persistence", {ensure => present})
    file_line { "persistence/${name}":
      line => "persistence/${name}",
      path => "${purge_state_dir}/persistence",
    }
  }
}
