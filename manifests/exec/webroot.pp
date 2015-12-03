# letsencrypt webroot
define letsencrypt::exec::webroot (
  $domains = [$name],
  $webroot = $letsencrypt::webroot,
  $server  = $letsencrypt::server,
){
  require letsencrypt
  validate_array($domains)

  $params_domain = join($domains, ' -d ')

  if $letsencrypt::firstrun_standalone and $::letsencrypt_firstrun != 'SUCCESS' {
    letsencrypt::exec::standalone{ $name:
      domains => $domains,
      server  => $server,
    } ->
    # TODO FIXME: This fails if defined multiple times
    file{ '/etc/facts.d/letsencrypt.txt':
      content => 'letsencrypt_firstrun=SUCCESS',
      owner   => root,
      group   => root,
      mode    => '0644',
    }
  } else {
    exec{ "letsencrypt-exec-webroot-${name}":
      command => "letsencrypt certonly -a webroot --webroot-path ${webroot} -d ${params_domain} --agree-dev-preview --renew-by-default --server ${server}",
      creates => "/etc/letsencrypt/live/${domains[0]}/fullchain.pem";
    }
  }
}
