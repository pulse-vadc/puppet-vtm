# === class: brocadevtm::log_export_data_plane_acceleration
#
# This class is a direct implementation of brocadvtm::log_export
#
# Please refer to the documentation in that module for more information
#
class brocadevtm::log_export_data_plane_acceleration (
  $ensure                = present,
  $basic__appliance_only = true,
  $basic__enabled        = true,
  $basic__files          = '["%ZEUSHOME%/zxtm/log/dpa_errors*"]',
  $basic__history        = 'none',
  $basic__history_period = 10,
  $basic__metadata       = '[{"name":"source","value":"dpalog"},{"name":"sourcetype","value":"zxtm_dpa_log"}]',
  $basic__note           = 'Log entries generated when running in Data Plane Acceleration mode.',
){
  include brocadevtm
  $ip              = $brocadevtm::rest_ip
  $port            = $brocadevtm::rest_port
  $user            = $brocadevtm::rest_user
  $pass            = $brocadevtm::rest_pass
  $purge           = $brocadevtm::purge
  $purge_state_dir = $brocadevtm::purge_state_dir

  info ("Configuring log_export_data_plane_acceleration ${name}")
  vtmrest { 'log_export/Data%20Plane%20Acceleration':
    ensure   => $ensure,
    before   => Class[brocadevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/5.2/config/active",
    username => $user,
    password => $pass,
    content  => template('brocadevtm/log_export.erb'),
    type     => 'application/json',
    internal => 'log_export_data_plane_acceleration',
    failfast => $brocadevtm::failfast,
    debug    => $brocadevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/log_export", {ensure => present})
    file_line { 'log_export/Data%20Plane%20Acceleration':
      line => 'log_export/Data%20Plane%20Acceleration',
      path => "${purge_state_dir}/log_export",
    }
  }
}
