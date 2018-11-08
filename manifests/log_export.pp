# === Define: pulsevtm::log_export
#
# Log Export
# Definitions of log files which should be exported to the analytics engine
#
# === Parameters
#
# [*basic__appliance_only*]
# Whether entries from the specified log files should be exported only from
# appliances.
#
# [*basic__enabled*]
# Export entries from the log files included in this category.
#
# [*basic__files*]
# The set of files to export as part of this category, specified as a list of
# glob patterns.
# Type:array
# Properties:
#
# [*basic__history*]
# How much historic log activity should be exported.
#
# [*basic__history_period*]
# The number of days of historic log entries that should be exported.
#
# [*basic__machines*]
# The set of traffic managers on which this log should be exported. '*' will
# select all traffic managers in the cluster.
# Type:array
# Properties:
#
# [*basic__metadata*]
# This is table 'metadata'
# Type:array
# Properties:{"name"=>{"description"=>"The name of a metadata item which
# should be sent to the analytics engine along with entries from these log
# files.", "type"=>"string"}, "value"=>{"description"=>"Additional metadata to
# include with the log entries when exporting them to the configured endpoint.
# Metadata can be used by the system that is receiving the exported data to
# categorise and parse the log entries.", "type"=>"string"}}
#
# [*basic__note*]
# A description of this category of log files.
#
# [*basic__preprocess*]
# The type of pre-processing that should be applied to log entries before they
# are exported.
#
# === Examples
#
# pulsevtm::log_export { 'example':
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
define pulsevtm::log_export (
  $ensure,
  $basic__appliance_only = false,
  $basic__enabled        = false,
  $basic__files          = '[]',
  $basic__history        = 'none',
  $basic__history_period = 10,
  $basic__metadata       = '[]',
  $basic__note           = undef,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring log_export ${name}")
  vtmrest { "log_export/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/log_export.erb'),
    type     => 'application/json',
    internal => 'log_export',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/log_export", {ensure => present})
    file_line { "log_export/${name}":
      line => "log_export/${name}",
      path => "${purge_state_dir}/log_export",
    }
  }
}
