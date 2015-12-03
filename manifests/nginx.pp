# nginx base config
class letsencrypt::nginx(
  $default_vhost = 'default'
) {
  include letsencrypt

  unless defined(Nginx::Resource::Vhost[$default_vhost]){
    nginx::resource::vhost{ 'default':
        listen_options => default_server,
        server_name    => ['default'],
        www_root       => $letsencrypt::webroot,
    }

  }
#  unless defined(Letsencrypt::Nginx::Location[$default_vhost]){
#    letsencrypt::nginx::location{$default_vhost:}
#  }
  ensure_resource('letsencrypt::nginx::location', $default_vhost )
}
