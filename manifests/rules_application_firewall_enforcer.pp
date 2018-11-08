# === class: pulsevtm::rules_application_firewall_enforcer

class pulsevtm::rules_application_firewall_enforcer (
  $ensure  = present,
  $content = file('pulsevtm/rules_application_firewall_enforcer.data'),
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring rules_application_firewall_enforcer ${name}")
  vtmrest { 'rules/Application%20Firewall%20Enforcer':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => $content,
    type     => 'application/octet-stream',
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/rules", {ensure => present})
    file_line { 'rules/Application%20Firewall%20Enforcer':
      line => 'rules/Application%20Firewall%20Enforcer',
      path => "${purge_state_dir}/rules",
    }
  }
}
