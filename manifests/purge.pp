# === Class: pulsevtm
#
# This defines the Brocade vTM access information.
#
# === Parameters
#
# === Examples
#
#  include pulsevtm::purge
#

class pulsevtm::purge {

  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  if ($purge) {
    vtmrest { 'purge':
      ensure   => present,
      endpoint => "https://${ip}:${port}/api/tm/3.3/config/active",
      username => $user,
      password => $pass,
      content  => $purge_state_dir,
      type     => 'purge',
      internal => 'none',
      debug    => $pulsevtm::debug,
    }

  }

}

