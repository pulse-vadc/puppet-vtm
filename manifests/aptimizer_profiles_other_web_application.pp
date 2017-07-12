# === Class: brocadevtm::aptimizer_profiles_other_web_application
#
# This class is a direct implementation of brocadvtm::aptimizer_profiles
#
# Please refer to the documentation in that module for more information
#
class brocadevtm::aptimizer_profiles_other_web_application (
  $ensure                                    = present,
  $basic__background_after                   = 0,
  $basic__background_on_additional_resources = false,
  $basic__mode                               = 'active',
  $basic__show_info_bar                      = true,
){
  include brocadevtm
  $ip              = $brocadevtm::rest_ip
  $port            = $brocadevtm::rest_port
  $user            = $brocadevtm::rest_user
  $pass            = $brocadevtm::rest_pass
  $purge           = $brocadevtm::purge
  $purge_state_dir = $brocadevtm::purge_state_dir

  info ("Configuring aptimizer_profiles_other_web_application ${name}")
  vtmrest { 'aptimizer/profiles/Other%20web%20application':
    ensure   => $ensure,
    before   => Class[Brocadevtm::Purge],
    endpoint => "https://${ip}:${port}/api/tm/5.0/config/active",
    username => $user,
    password => $pass,
    content  => template('brocadevtm/aptimizer_profiles.erb'),
    type     => 'application/json',
    internal => 'aptimizer_profiles_other_web_application',
    failfast => $brocadevtm::failfast,
    debug    => 0,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/aptimizer_profiles", {ensure => present})
    file_line { 'aptimizer/profiles/Other%20web%20application':
      line => 'aptimizer/profiles/Other%20web%20application',
      path => "${purge_state_dir}/aptimizer_profiles",
    }
  }
}
