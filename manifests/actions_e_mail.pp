# === class: pulsevtm::actions_e_mail
#
# This class is a direct implementation of brocadvtm::actions
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::actions_e_mail (
  $ensure                      = present,
  $basic__note                 = undef,
  $basic__syslog_msg_len_limit = 1024,
  $basic__timeout              = 60,
  $basic__type                 = 'email',
  $basic__verbose              = false,
  $email__from                 = 'vTM@%hostname%',
  $email__server               = undef,
  $email__to                   = '[]',
  $log__file                   = undef,
  $program__arguments          = '[]',
  $program__program            = undef,
  $soap__additional_data       = undef,
  $soap__password              = undef,
  $soap__proxy                 = undef,
  $soap__username              = undef,
  $syslog__sysloghost          = undef,
  $trap__auth_password         = undef,
  $trap__community             = undef,
  $trap__hash_algorithm        = 'md5',
  $trap__priv_password         = undef,
  $trap__traphost              = undef,
  $trap__username              = undef,
  $trap__version               = 'snmpv1',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring actions_e_mail ${name}")
  vtmrest { 'actions/E-Mail':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/actions.erb'),
    type     => 'application/json',
    internal => 'actions_e_mail',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/actions", {ensure => present})
    file_line { 'actions/E-Mail':
      line => 'actions/E-Mail',
      path => "${purge_state_dir}/actions",
    }
  }
}
