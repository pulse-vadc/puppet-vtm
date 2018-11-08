# === class: pulsevtm::aptimizer_profiles_sharepoint_2013_custom_website
#
# This class is a direct implementation of brocadvtm::aptimizer_profiles
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::aptimizer_profiles_sharepoint_2013_custom_website (
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

  info ("Configuring aptimizer_profiles_sharepoint_2013_custom_website ${name}")
  vtmrest { 'aptimizer/profiles/SharePoint%202013%20Custom%20Website':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/aptimizer_profiles.erb'),
    type     => 'application/json',
    internal => 'aptimizer_profiles_sharepoint_2013_custom_website',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/aptimizer_profiles", {ensure => present})
    file_line { 'aptimizer/profiles/SharePoint%202013%20Custom%20Website':
      line => 'aptimizer/profiles/SharePoint%202013%20Custom%20Website',
      path => "${purge_state_dir}/aptimizer_profiles",
    }
  }
}
