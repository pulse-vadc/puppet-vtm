# === class: pulsevtm::monitor_scripts_dns_pl

class pulsevtm::monitor_scripts_dns_pl (
  $ensure  = present,
  $content = file('pulsevtm/monitor_scripts_dns_pl.data'),
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring monitor_scripts_dns_pl ${name}")
  vtmrest { 'monitor_scripts/dns.pl':
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
    ensure_resource('file', "${purge_state_dir}/monitor_scripts", {ensure => present})
    file_line { 'monitor_scripts/dns.pl':
      line => 'monitor_scripts/dns.pl',
      path => "${purge_state_dir}/monitor_scripts",
    }
  }
}
