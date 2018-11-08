# === Define: pulsevtm::aptimizer_profiles
#
# Web Accelerator Profile
# A Web Accelerator profile can be applied to an HTTP virtual server to enable
# automatic web content optimization.
#
# === Parameters
#
# [*basic__background_after*]
# If Web Accelerator can finish optimizing the resource within this time limit
# then serve the optimized content to the client, otherwise complete the
# optimization in the background and return the original content to the
# client. If set to 0, Web Accelerator will always wait for the optimization
# to complete before sending a response to the client.
#
# [*basic__background_on_additional_resources*]
# If a web page contains resources that have not yet been optimized, fetch and
# optimize those resources in the background and send a partially optimized
# web page to clients until all resources on that page are ready.
#
# [*basic__config*]
# Placeholder to be overwritten when we have Web Accelerator support in RESTD
#
# [*basic__mode*]
# Set the Web Accelerator mode to turn acceleration on or off.
#
# [*basic__show_info_bar*]
# Show the Web Accelerator information bar on optimized web pages. This
# requires HTML optimization to be enabled in the acceleration settings.
#
# === Examples
#
# pulsevtm::aptimizer_profiles { 'example':
#     ensure => present,
# }
#
#
# === Authors
#
#  Pulse Secure <puppet-vadc@pulsesecure.net>
#
# === Copyright
#
# Copyright 2018 Pulse Secure
#
define pulsevtm::aptimizer_profiles (
  $ensure,
  $basic__background_after                   = 0,
  $basic__background_on_additional_resources = false,
  $basic__mode                               = 'active',
  $basic__show_info_bar                      = false,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring aptimizer_profiles ${name}")
  vtmrest { "aptimizer/profiles/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/aptimizer_profiles.erb'),
    type     => 'application/json',
    internal => 'aptimizer_profiles',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/aptimizer_profiles", {ensure => present})
    file_line { "aptimizer/profiles/${name}":
      line => "aptimizer/profiles/${name}",
      path => "${purge_state_dir}/aptimizer_profiles",
    }
  }
}
