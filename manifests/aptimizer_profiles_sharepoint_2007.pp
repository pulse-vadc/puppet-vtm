# === class: pulsevtm::aptimizer_profiles_sharepoint_2007
#
# This class is a direct implementation of brocadvtm::aptimizer_profiles
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::aptimizer_profiles_sharepoint_2007 (
  $ensure                                    = present,
  $basic__background_after                   = 0,
  $basic__background_on_additional_resources = false,
  $basic__mode                               = 'active',
  $basic__show_info_bar                      = true,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring aptimizer_profiles_sharepoint_2007 ${name}")
  vtmrest { 'aptimizer/profiles/SharePoint%202007':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/aptimizer_profiles.erb'),
    type     => 'application/json',
    internal => 'aptimizer_profiles_sharepoint_2007',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/aptimizer_profiles", {ensure => present})
    file_line { 'aptimizer/profiles/SharePoint%202007':
      line => 'aptimizer/profiles/SharePoint%202007',
      path => "${purge_state_dir}/aptimizer_profiles",
    }
  }
}
