# Let's Encrypt
# == Class: letsencrypt
#
# Full description of class letsencrypt here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'letsencrypt':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class letsencrypt(
  $email,
  $webroot             = '/var/lib/letsencrypt/webroot',
  $server              = 'https://acme-v01.api.letsencrypt.org/directory', # https://acme-staging.api.letsencrypt.org/directory
  $firstrun_standalone = true,
  $rsa_key_size        = '2048',
  $config_dir          = '/etc/letsencrypt',
  $work_dir            = '/var/lib/letsencrypt',
  $logs_dir            = '/var/log/letsencrypt',
  $nginx_vhosts        = {},
  $exec_webroot        = {},
  $exec_standalone     = {},
) {
  require letsencrypt::install

  if $webroot == '/var/lib/letsencrypt/webroot' {
    file{ [
        '/var/lib/letsencrypt',
        '/var/lib/letsencrypt/webroot',
      ]:
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => '0644';
    }
  }

  file{'/etc/letsencrypt/cli.ini':
    content => template('letsencrypt/cli.ini.erb'),
    owner   => root,
    group   => root,
    mode    => '0640';
  }
  create_resources('letsencrypt::nginx::vhost', $nginx_vhosts)
  create_resources('letsencrypt::exec::webroot', $exec_webroot)
  create_resources('letsencrypt::exec::standalone', $exec_standalone)
}
