# === class: pulsevtm::servicediscovery_builtin_gce

class pulsevtm::servicediscovery_builtin_gce (
  $ensure  = present,
  $content = file('pulsevtm/servicediscovery_builtin_gce.data'),
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring servicediscovery_builtin_gce ${name}")
  vtmrest { 'servicediscovery/BuiltIn-GCE':
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
    ensure_resource('file', "${purge_state_dir}/servicediscovery", {ensure => present})
    file_line { 'servicediscovery/BuiltIn-GCE':
      line => 'servicediscovery/BuiltIn-GCE',
      path => "${purge_state_dir}/servicediscovery",
    }
  }
}
