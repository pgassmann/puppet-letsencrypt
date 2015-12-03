# Configure acme-challenge location webroot
define letsencrypt::nginx::location(
  $vhost    = $name,
){
  include letsencrypt::nginx
  # if vhost is set as default_vhost, then the location is already added.
  unless defined(Nginx::Resource::Location["${vhost}-letsencrypt"]) {
    if defined(Nginx::Resource::Vhost[$vhost]){
      $vhost_ssl = getparam(Nginx::Resource::Vhost[$vhost], 'ssl')
    } else {
      $vhost_ssl = true
    }
    # getparam returns undef if specified false or if not defined.
    # Set it to default of vhost param ssl.
    if $vhost_ssl == undef {
      $real_vhost_ssl = false
    } else {
      $real_vhost_ssl = $vhost_ssl
    }
    validate_bool($real_vhost_ssl)
    nginx::resource::location{"${vhost}-letsencrypt":
      vhost    =>  $vhost,
      location =>  '/.well-known/acme-challenge',
      www_root =>  $letsencrypt::webroot,
      ssl      =>  $real_vhost_ssl,
    }
  }
}
