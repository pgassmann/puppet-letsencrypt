# letsencrypt webroot
define letsencrypt::exec::webroot (
  $domains = [$name],
  $webroot = $letsencrypt::webroot,
  $server  = $letsencrypt::server,
){
  include letsencrypt
  validate_array($domains)
  validate_string($server)
  validate_string($webroot)

  $params_domain = join($domains, ' -d ')

  if $letsencrypt::firstrun_standalone and $::letsencrypt_firstrun != 'SUCCESS' {
    letsencrypt::exec::standalone{ $name:
      domains => $domains,
      server  => $server,
    }
    # TODO FIXME: This fails if webroot is defined multiple times
    file{ ['/etc/facter', '/etc/facter/facts.d']: ensure => directory; }
    file{ '/etc/facter/facts.d/letsencrypt.txt':
      content => 'letsencrypt_firstrun=SUCCESS',
      owner   => root,
      group   => root,
      mode    => '0644',
      require => Letsencrypt::Exec::Standalone[$name];
    }
  } else {
    if $letsencrypt::firstrun_webroot and $::letsencrypt_firstrun != 'SUCCESS'{
      $real_webroot = $letsencrypt::firstrun_webroot
      # TODO FIXME: This fails if webroot is defined multiple times
      file{ ['/etc/facter', '/etc/facter/facts.d']: ensure => directory; }
      file{ '/etc/facter/facts.d/letsencrypt.txt':
        content => 'letsencrypt_firstrun=SUCCESS',
        owner   => root,
        group   => root,
        mode    => '0644',
        require => Exec["letsencrypt-exec-webroot-${name}"],
      }
    } else {
    $real_webroot = $webroot
    }
    exec{ "letsencrypt-exec-webroot-${name}":
      command => "letsencrypt certonly -a webroot --webroot-path ${real_webroot} -d ${params_domain} --renew-by-default --server ${server}",
      creates => "/etc/letsencrypt/live/${domains[0]}/fullchain.pem",
      require  => File['/etc/letsencrypt/cli.ini'];
    }
  }
}
