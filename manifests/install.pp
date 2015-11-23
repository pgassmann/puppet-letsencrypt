# install letsencrypt client
class letsencrypt::install(
  $source           = 'git',
  $git_source       = 'https://github.com/letsencrypt/letsencrypt.git',
  $git_revision     = 'master',
  $letsencrypt_auto = true,
) {

  case $source {
    'git': {
      vcsrepo { '/opt/letsencrypt':
        ensure   => present,
        provider => git,
        source   => $git_source,
        revision => $git_revision,
      }
      if $letsencrypt_auto {
        $exec = '/opt/letsencrypt/letsencrypt-auto'
      } else {
        fail('Currently only letsencrypt_auto is supported')
      }
      # Link does not work, create wrapper
      file{'/usr/local/bin/letsencrypt':
        content => "#!/bin/bash\npushd /opt/letsencrypt/ \n ./letsencrypt-auto \"$@\" \npopd\n",
        owner   => root,
        group   => root,
        mode    => '0750';
      }
    }
    default: {
      fail("letsencrypt::install::source '${source}' not yet supported")
    }
  }
}
