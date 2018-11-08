# === class: pulsevtm::log_export_system___syslog
#
# This class is a direct implementation of brocadvtm::log_export
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::log_export_system___syslog (
  $ensure                = present,
  $basic__appliance_only = true,
  $basic__enabled        = true,
  $basic__files          = '["/var/log/syslog*"]',
  $basic__history        = 'none',
  $basic__history_period = 10,
  $basic__metadata       = '[{"name":"source","value":"syslog"},{"name":"sourcetype","value":"syslog"}]',
  $basic__note           = 'The operating system\'s syslog.',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring log_export_system___syslog ${name}")
  vtmrest { 'log_export/System%20-%20syslog':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/log_export.erb'),
    type     => 'application/json',
    internal => 'log_export_system___syslog',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/log_export", {ensure => present})
    file_line { 'log_export/System%20-%20syslog':
      line => 'log_export/System%20-%20syslog',
      path => "${purge_state_dir}/log_export",
    }
  }
}
