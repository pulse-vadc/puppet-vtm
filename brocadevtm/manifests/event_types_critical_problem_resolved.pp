# === Class: brocadevtm::event_types_critical_problem_resolved
#

class brocadevtm::event_types_critical_problem_resolved (
  $ensure = present,
  $basic__actions               = [],
  $basic__built_in              = true,
  $basic__note                  = "Triggered when a critical problem recovers.",
  $cloudcredentials__event_tags = [],
  $cloudcredentials__objects    = [],
  $config__event_tags           = [],
  $faulttolerance__event_tags   = ["allmachinesok", "flipperbackendsworking", "dropipinfo", "flipperfrontendsworking", "machineok", "flipperraiselocalworking", "flipperrecovered", "activatealldead", "activatedautomatically", "routingswoperational"],
  $general__event_tags          = [],
  $glb__event_tags              = [],
  $glb__objects                 = [],
  $java__event_tags             = ["javastarted"],
  $licensekeys__event_tags      = ["usinglicense"],
  $licensekeys__objects         = ["*"],
  $locations__event_tags        = [],
  $locations__objects           = [],
  $monitors__event_tags         = ["monitorok"],
  $monitors__objects            = ["*"],
  $pools__event_tags            = ["poolok", "nodeworking"],
  $pools__objects               = ["*"],
  $protection__event_tags       = [],
  $protection__objects          = ["*"],
  $rules__event_tags            = [],
  $rules__objects               = [],
  $slm__event_tags              = ["slmnodeinfo", "slmrecoveredserious"],
  $slm__objects                 = ["*"],
  $ssl__event_tags              = [],
  $sslhw__event_tags            = ["sslhwrestart", "sslhwstart"],
  $trafficscript__event_tags    = [],
  $vservers__event_tags         = [],
  $vservers__objects            = [],
  $zxtms__event_tags            = [],
  $zxtms__objects               = [],
){
  include brocadevtm
  $ip   = $brocadevtm::rest_ip
  $port = $brocadevtm::rest_port
  $user = $brocadevtm::rest_user
  $pass = $brocadevtm::rest_pass

  info ("Configuring event_types_critical_problem_resolved ${name}")
  vtmrest { "event_types/Critical%20Problem%20Resolved":
    endpoint => "https://${ip}:${port}/api/tm/3.3/config/active",
    ensure => $ensure,
    username => $user,
    password => $pass,
    content => template('brocadevtm/event_types.erb'),
    type => 'application/json',
    internal => 'event_types_critical_problem_resolved',
    debug => 0,
  }
}