# === class: pulsevtm::log_export_system___authentication_log
#
# This class is a direct implementation of brocadvtm::log_export
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::log_export_system___authentication_log (
  $ensure                = present,
  $basic__appliance_only = true,
  $basic__enabled        = true,
  $basic__files          = '["/var/log/auth.log*"]',
  $basic__history        = 'none',
  $basic__history_period = 10,
  $basic__metadata       = '[{"name":"source","value":"authlog"},{"name":"sourcetype","value":"syslog"}]',
  $basic__note           = 'The operating system\'s authentication log.',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring log_export_system___authentication_log ${name}")
  vtmrest { 'log_export/System%20-%20authentication%20log':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/log_export.erb'),
    type     => 'application/json',
    internal => 'log_export_system___authentication_log',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/log_export", {ensure => present})
    file_line { 'log_export/System%20-%20authentication%20log':
      line => 'log_export/System%20-%20authentication%20log',
      path => "${purge_state_dir}/log_export",
    }
  }
}
