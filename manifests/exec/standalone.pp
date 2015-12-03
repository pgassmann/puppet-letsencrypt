# letsencrypt standalone
define letsencrypt::exec::standalone (
  $domains = [$name],
  $server  = $letsencrypt::server,
){
  validate_array($domains)

  $params_domain = join($domains, ' -d ')
  exec{ "letsencrypt-exec-standalone-${name}":
    command  => "letsencrypt certonly -a standalone -d ${params_domain} --agree-dev-preview --renew-by-default --server ${server}",
    creates  => "/etc/letsencrypt/live/${domains[0]}/fullchain.pem";
  }
}
