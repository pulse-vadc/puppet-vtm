# === class: pulsevtm::event_types_resource_starvation
#
# This class is a direct implementation of brocadvtm::event_types
#
# Please refer to the documentation in that module for more information
#
class pulsevtm::event_types_resource_starvation (
  $ensure                       = present,
  $basic__actions               = '[]',
  $basic__built_in              = true,
  $basic__note                  = 'Events triggered when we have run out of system resources or hit a configured limit in the Virtual Traffic Manager.',
  $cloudcredentials__event_tags = '[]',
  $cloudcredentials__objects    = '[]',
  $config__event_tags           = '[]',
  $faulttolerance__event_tags   = '[]',
  $general__event_tags          = '["fewfreefds"]',
  $glb__event_tags              = '[]',
  $glb__objects                 = '[]',
  $java__event_tags             = '[]',
  $licensekeys__event_tags      = '[]',
  $licensekeys__objects         = '[]',
  $locations__event_tags        = '[]',
  $locations__objects           = '[]',
  $monitors__event_tags         = '[]',
  $monitors__objects            = '[]',
  $pools__event_tags            = '[]',
  $pools__objects               = '[]',
  $protection__event_tags       = '[]',
  $protection__objects          = '[]',
  $rules__event_tags            = '["rulebufferlarge"]',
  $rules__objects               = '["*"]',
  $slm__event_tags              = '[]',
  $slm__objects                 = '[]',
  $ssl__event_tags              = '[]',
  $sslhw__event_tags            = '[]',
  $trafficscript__event_tags    = '[]',
  $vservers__event_tags         = '["maxclientbufferdrop","responsetoolarge","rtspstreamnoports","sipstreamnoports"]',
  $vservers__objects            = '["*"]',
  $zxtms__event_tags            = '[]',
  $zxtms__objects               = '[]',
){
  include pulsevtm
  $ip              = $pulsevtm::rest_ip
  $port            = $pulsevtm::rest_port
  $user            = $pulsevtm::rest_user
  $pass            = $pulsevtm::rest_pass
  $purge           = $pulsevtm::purge
  $purge_state_dir = $pulsevtm::purge_state_dir

  info ("Configuring event_types_resource_starvation ${name}")
  vtmrest { 'event_types/Resource%20Starvation':
    ensure   => $ensure,
    before   => Class[pulsevtm::purge],
    endpoint => "https://${ip}:${port}/api/tm/6.0/config/active",
    username => $user,
    password => $pass,
    content  => template('pulsevtm/event_types.erb'),
    type     => 'application/json',
    internal => 'event_types_resource_starvation',
    failfast => $pulsevtm::failfast,
    debug    => $pulsevtm::debug,
  }

  if ( $purge ) {
    ensure_resource('file', "${purge_state_dir}/event_types", {ensure => present})
    file_line { 'event_types/Resource%20Starvation':
      line => 'event_types/Resource%20Starvation',
      path => "${purge_state_dir}/event_types",
    }
  }
}
