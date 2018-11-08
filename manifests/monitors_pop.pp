# === class: pulsevtm::monitors_pop
#
# This class is a direct implementation of brocadvtm::monitors
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::monitors_pop (
  $ensure                = present,
  $basic__back_off       = true,
  $basic__delay          = 5,
  $basic__failures       = 3,
  $basic__health_only    = false,
  $basic__machine        = undef,
  $basic__note           = undef,
  $basic__scope          = 'pernode',
  $basic__timeout        = 5,
  $basic__type           = 'tcp_transaction',
  $basic__use_ssl        = false,
  $basic__verbose        = false,
  $http__authentication  = undef,
  $http__body_regex      = undef,
  $http__host_header     = undef,
  $http__path            = '/',
  $http__status_regex    = '^[234][0-9][0-9]$',
  $rtsp__body_regex      = undef,
  $rtsp__path            = '/',
  $rtsp__status_regex    = '^[234][0-9][0-9]$',
  $script__arguments     = '[]',
  $script__program       = undef,
  $sip__body_regex       = undef,
  $sip__status_regex     = '^[234][0-9][0-9]$',
  $sip__transport        = 'udp',
  $tcp__close_string     = 'QUIT\\\\r\\\\n',
  $tcp__max_response_len = 2048,
  $tcp__response_regex   = '^\\\\+OK [^\\\\n]+\\\\n',
  $tcp__write_string     = undef,
  $udp__accept_all       = false,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring monitors_pop ${name}")
  vtmrest { 'monitors/POP':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/monitors.erb'),
    type     => 'application/json',
    internal => 'monitors_pop',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/monitors", {ensure => present})
    file_line { 'monitors/POP':
      line => 'monitors/POP',
      path => "${purge_state_dir}/monitors",
    }
  }
}
