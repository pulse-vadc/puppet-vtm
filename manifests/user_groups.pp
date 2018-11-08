# === Define: pulsevtm::user_groups
#
# User Group
# Permission groups specify permissions for groups of users. These groups can
# be given read-write or read-only access to different parts of the
# configuration hierarchy. Each group will contain a table of permissions.
# Each table entry has a name that corresponds to a part of the configuration
# hierarchy, and a corresponding access level. The access level may have
# values of either "none", "ro" (read only, this is the default), or "full".
# Some permissions have sub-permissions, these are denoted by following the
# parent permission name with a colon (":") followed by the sub-permission
# name.  The built-in "admin" group has a special permission key of "all" with
# the value "full", this must not be altered for the "admin" group but can be
# used in other group configuration files to change the default permission
# level for the group.
#
# === Parameters
#
# [*basic__description*]
# A description for the group.
#
# [*basic__password_expire_time*]
# Members of this group must renew their passwords after this number of days.
# To disable password expiry for the group set this to "0" (zero). Note that
# this setting applies only to local users.
#
# [*basic__permissions*]
# A table defining which level of permission this group has for specific
# configuration elements.
# Type:array
# Properties:{"name"=>{"description"=>"Configuration element to which this
# group has a level of permission.", "type"=>"string"},
# "access_level"=>{"description"=>"Permission level for the configuration
# element (none, ro or full)", "type"=>"string",
# "pattern"=>"^(none|ro|full)$"}}
#
# [*basic__timeout*]
# Inactive UI sessions will timeout after this number of seconds. To disable
# inactivity timeouts for the group set this to "0" (zero).
#
# === Examples
#
# pulsevtm::user_groups { 'example':
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
define pulsevtm::user_groups (
  $ensure,
  $basic__description          = undef,
  $basic__password_expire_time = 0,
  $basic__permissions          = '[]',
  $basic__timeout              = 30,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring user_groups ${name}")
  vtmrest { "user_groups/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/user_groups.erb'),
    type     => 'application/json',
    internal => 'user_groups',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/user_groups", {ensure => present})
    file_line { "user_groups/${name}":
      line => "user_groups/${name}",
      path => "${purge_state_dir}/user_groups",
    }
  }
}
