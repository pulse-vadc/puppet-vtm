# === Class: brocadevtm::event_types_ssl_certificate_expiry
#

class brocadevtm::event_types_ssl_certificate_expiry (
  $ensure = present,
  $basic__actions               = [],
  $basic__built_in              = true,
  $basic__note                  = "Warnings about SSL certificates that have expired or are about to.",
  $cloudcredentials__event_tags = [],
  $cloudcredentials__objects    = [],
  $config__event_tags           = [],
  $faulttolerance__event_tags   = [],
  $general__event_tags          = [],
  $glb__event_tags              = [],
  $glb__objects                 = [],
  $java__event_tags             = [],
  $licensekeys__event_tags      = [],
  $licensekeys__objects         = [],
  $locations__event_tags        = [],
  $locations__objects           = [],
  $monitors__event_tags         = [],
  $monitors__objects            = [],
  $pools__event_tags            = [],
  $pools__objects               = [],
  $protection__event_tags       = [],
  $protection__objects          = [],
  $rules__event_tags            = [],
  $rules__objects               = [],
  $slm__event_tags              = [],
  $slm__objects                 = [],
  $ssl__event_tags              = [],
  $sslhw__event_tags            = [],
  $trafficscript__event_tags    = [],
  $vservers__event_tags         = ["vscacertexpired", "vscacerttoexpire", "vscrloutofdate", "vssslcertexpired", "vssslcerttoexpire"],
  $vservers__objects            = ["*"],
  $zxtms__event_tags            = [],
  $zxtms__objects               = [],
){
  include brocadevtm
  $ip   = $brocadevtm::rest_ip
  $port = $brocadevtm::rest_port
  $user = $brocadevtm::rest_user
  $pass = $brocadevtm::rest_pass

  info ("Configuring event_types_ssl_certificate_expiry ${name}")
  vtmrest { "event_types/SSL%20Certificate%20Expiry":
    endpoint => "https://${ip}:${port}/api/tm/3.3/config/active",
    ensure => $ensure,
    username => $user,
    password => $pass,
    content => template('brocadevtm/event_types.erb'),
    type => 'application/json',
    internal => 'event_types_ssl_certificate_expiry',
    debug => 0,
  }
}