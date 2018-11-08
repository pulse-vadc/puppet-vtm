# === class: pulsevtm::log_export_application_firewall
#
# This class is a direct implementation of brocadvtm::log_export
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::log_export_application_firewall (
  $ensure                = present,
  $basic__appliance_only = false,
  $basic__enabled        = true,
  $basic__files          = '["%ZEUSHOME%/zxtm/log/stingrayafm/log-master/*","%ZEUSHOME%/zxtm/log/stingrayafm/log/*"]',
  $basic__history        = 'none',
  $basic__history_period = 10,
  $basic__metadata       = '[{"name":"source","value":"waflog"},{"name":"sourcetype","value":"zxtm_waf_log"}]',
  $basic__note           = 'Log files from all application firewall processes.',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring log_export_application_firewall ${name}")
  vtmrest { 'log_export/Application%20Firewall':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/log_export.erb'),
    type     => 'application/json',
    internal => 'log_export_application_firewall',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/log_export", {ensure => present})
    file_line { 'log_export/Application%20Firewall':
      line => 'log_export/Application%20Firewall',
      path => "${purge_state_dir}/log_export",
    }
  }
}
