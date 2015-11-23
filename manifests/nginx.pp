# nginx base config
class letsencrypt::nginx(
  $default_vhost = 'default'
) {
  include letsencrypt

  if defined(Nginx::Resource::Vhost[$default_vhost]) {
    $vhost_ssl = getparam(Nginx::Resource::Vhost[$default_vhost], 'ssl')
    nginx::resource::location{"${default_vhost}-letsencrypt":
      vhost    =>  $default_vhost,
      location =>  '/.well-known/acme-challenge',
      www_root =>  $letsencrypt::webroot,
      ssl      =>  $vhost_ssl,
    }
  }
}
