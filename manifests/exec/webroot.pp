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
    file{ '/etc/facts.d/letsencrypt.txt':
      content => 'letsencrypt_firstrun=SUCCESS',
      owner   => root,
      group   => root,
      mode    => '0644',
    }
  } else {
    exec{ "letsencrypt-exec-webroot-${name}":
      command => "letsencrypt certonly -a webroot --webroot-path ${webroot} -d ${params_domain} --agree-dev-preview --server ${server} --renew-by-default",
      creates => "/etc/letsencrypt/live/${domains[0]}/fullchain.pem";
    }
  }
}
