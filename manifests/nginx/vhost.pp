# Automatically get ssl certificate for nginx vhost
define letsencrypt::nginx::vhost(
  $vhost    = $name,
  $domains  = undef,
){
  include letsencrypt
  require letsencrypt::nginx

  if defined(Nginx::Resource::Vhost[$vhost]){
    if $domains {
      validate_array($domains)
      $real_domains = $domains
    } else {
      $real_domains = getparam(Nginx::Resource::Vhost[$vhost], 'server_name')
    }
  } else {
    if $domains {
      validate_array($domains)
      $real_domains = $domains
    } else {
      fail("Nginx::Resource::Vhost[${vhost}] is not yet defined and domains are not specified, make sure that letsencrypt::nginx::vhost is parsed after nginx::resource::vhost")
    }
  }

  # if vhost is set as default_vhost, then the location is already added.
  unless defined(Nginx::Resource::Location["${vhost}-letsencrypt"]) {
    $vhost_ssl = getparam(Nginx::Resource::Vhost[$vhost], 'ssl')
    nginx::resource::location{"${vhost}-letsencrypt":
      vhost    =>  $vhost,
      location =>  '/.well-known/acme-challenge',
      www_root =>  $letsencrypt::webroot,
      ssl      =>  $vhost_ssl,
    }
  }

  letsencrypt::exec::webroot{ $name:
    domains => $real_domains,
    before  => Service['nginx'];
  }
}
