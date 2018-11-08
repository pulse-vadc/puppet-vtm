# === class: pulsevtm::servicediscovery_builtin_dns_resolver

class pulsevtm::servicediscovery_builtin_dns_resolver (
  $ensure  = present,
  $content = file('pulsevtm/servicediscovery_builtin_dns_resolver.data'),
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring servicediscovery_builtin_dns_resolver ${name}")
  vtmrest { 'servicediscovery/BuiltIn-DNS_Resolver':
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
    file_line { 'servicediscovery/BuiltIn-DNS_Resolver':
      line => 'servicediscovery/BuiltIn-DNS_Resolver',
      path => "${purge_state_dir}/servicediscovery",
    }
  }
}
