# === Define: pulsevtm::cloud_api_credentials
#
# Cloud Credentials
# Cloud credentials used in cloud API calls
#
# === Parameters
#
# [*basic__api_server*]
# The vCenter server hostname or IP address.
#
# [*basic__cloud_api_timeout*]
# The traffic manager creates and destroys nodes via API calls. This setting
# specifies (in seconds) how long to wait for such calls to complete.
#
# [*basic__cred1*]
# The first part of the credentials for the cloud user.  Typically this is
# some variation on the username concept.
#
# [*basic__cred2*]
# The second part of the credentials for the cloud user.  Typically this is
# some variation on the password concept.
#
# [*basic__cred3*]
# The third part of the credentials for the cloud user.  Typically this is
# some variation on the authentication token concept.
#
# [*basic__script*]
# The script to call for communication with the cloud API.
#
# [*basic__update_interval*]
# The traffic manager will periodically check the status of the cloud through
# an API call. This setting specifies the interval between such updates.
#
# === Examples
#
# pulsevtm::cloud_api_credentials { 'example':
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
define pulsevtm::cloud_api_credentials (
  $ensure,
  $basic__api_server        = undef,
  $basic__cloud_api_timeout = 200,
  $basic__cred1             = undef,
  $basic__cred2             = undef,
  $basic__cred3             = undef,
  $basic__script            = undef,
  $basic__update_interval   = 30,
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring cloud_api_credentials ${name}")
  vtmrest { "cloud_api_credentials/${name}":
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/cloud_api_credentials.erb'),
    type     => 'application/json',
    internal => 'cloud_api_credentials',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/cloud_api_credentials", {ensure => present})
    file_line { "cloud_api_credentials/${name}":
      line => "cloud_api_credentials/${name}",
      path => "${purge_state_dir}/cloud_api_credentials",
    }
  }
}
