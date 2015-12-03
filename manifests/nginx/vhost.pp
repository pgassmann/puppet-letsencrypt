# Let's Encrypt
# == Define: letsencrypt::nginx::vhost
#
# Automatically get ssl certificate for nginx vhost
#
# === Parameters
#
# Document parameters here.
#
# [*domains*]
#  Array of domains to get ssl certificate for.
#  If not define, it uses the server_name array defined in the vhost.
#  Use these domains instead of reading server_name array of vhost.
#
# [*exclude_domains*]
#  Array of servernames that should not be added as alt names for the ssl cert.
#  E.g. Elements of server_name that are defined in the vhost,
#  but are not public resolvable or not valid fqdns.
#
define letsencrypt::nginx::vhost(
  $vhost           = $name,
  $domains         = undef,
  $exclude_domains = [],
){
  validate_array($exclude_domains)

  include letsencrypt
  require letsencrypt::nginx

  if defined(Nginx::Resource::Vhost[$vhost]){
    if $domains {
      validate_array($domains)
      $real_domains = delete($domains, $exclude_domains)
    } else {
      $vhost_domains = getparam(Nginx::Resource::Vhost[$vhost], 'server_name')
      $real_domains  = delete($vhost_domains, $exclude_domains)
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
  ensure_resource('letsencrypt::nginx::location', $vhost )

  letsencrypt::exec::webroot{ $name:
    domains => $real_domains,
    before  => Service['nginx'];
  }
}
