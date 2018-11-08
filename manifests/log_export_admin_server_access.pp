# === class: pulsevtm::log_export_admin_server_access
#
# This class is a direct implementation of brocadvtm::log_export
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::log_export_admin_server_access (
  $ensure                = present,
  $basic__appliance_only = false,
  $basic__enabled        = false,
  $basic__files          = '["%ZEUSHOME%/admin/log/access*"]',
  $basic__history        = 'none',
  $basic__history_period = 10,
  $basic__metadata       = '[{"name":"source","value":"adminaccesslog"},{"name":"sourcetype","value":"access_combined"}]',
  $basic__note           = 'The Administration Server access log.',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring log_export_admin_server_access ${name}")
  vtmrest { 'log_export/Admin%20Server%20Access':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/log_export.erb'),
    type     => 'application/json',
    internal => 'log_export_admin_server_access',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/log_export", {ensure => present})
    file_line { 'log_export/Admin%20Server%20Access':
      line => 'log_export/Admin%20Server%20Access',
      path => "${purge_state_dir}/log_export",
    }
  }
}
