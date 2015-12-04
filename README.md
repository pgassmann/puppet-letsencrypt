# letsencrypt

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with letsencrypt](#setup)
    * [What letsencrypt affects](#what-letsencrypt-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with letsencrypt](#beginning-with-letsencrypt)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The goal of [Let's Encrypt](https://letsencrypt.org) is to automate ssl certificates.
The tool to automate server configuration is Puppet.
This module bridges the two efforts.

WARNING! This module is not ready yet!

## Module Description

The goal of this module is to enable ssl on puppet managed resources like nginx_vhosts as
simple as possible. The module reuses the domains configured in the vhost server_name

For the authorization, the webroot challenge is used and a custom location is
automatically added to the ngninx vhost so that the challenge path is using
the letsencrypt webroot.
This allows to solve the challenge even if the vhost is just a proxy to another server.

## Setup

### What letsencrypt affects

WARNING! This module is not ready yet!

TODO

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

Requests to Port 80 (and 433) of the IPv4 address of the domains to encrypt need to reach your server.

### Beginning with letsencrypt

See the following example for encrypting a nginx vhost.
This will successfully configure nginx, the vhost and the ssl certificat in one run, if added to a blank Server.

Important: You should declare letsencrypt resources after the nginx resources.
The fetching of the configured domains is parse order dependent.


#### Let's encrypt nginx vhost
    class{'nginx':
      nginx_vhosts => {
        'letsencrypt-test1.example.com' => {
              server_name      => [
                'letsencrypt-test1.example.com',
                'letsencrypt-test2.example.com',
              ],
              proxy            => 'http://10.1.2.3',
              ssl              => true,
              rewrite_to_https => true,
              ssl_key          => '/etc/letsencrypt/live/letsencrypt-test1.example.com/privkey.pem',
              ssl_cert         => '/etc/letsencrypt/live/letsencrypt-test1.example.com/fullchain.pem',

        },
      },
    }
    class { 'letsencrypt':
      email            => 'email@example.com',
      agree_tos        => true
      firstrun_webroot => '/usr/share/nginx/html'
      nginx_vhosts     => {
        'letsencrypt-test1.example.com' => {}
      }
    }

To add ssl configuration to an existing installation, you need first to configure the nginx_locations
for your default vhost and your existing vhost.

    class { 'letsencrypt':
      email            => 'email@example.com',
      agree_tos        => true
      nginx_locations     => {
        'default' => {}
        'letsencrypt-test1.example.com' => {}
      }
    }

If this is applied successfully, you can then add the ssl configuration to your nginx vhost as above and declare your letsencrypt::nginx::vhost

#### Hiera example

    classes:
      - nginx
      - letsencrypt

    nginx::nginx_vhosts:
      'letsencrypt-test1.example.com':
          server_name:
                                - 'letsencrypt-test1.example.com'
                                - 'letsencrypt-test2.example.com'
          proxy:                'http://10.1.2.3'
          ssl:                  true
          rewrite_to_https:     true
          ssl_key:              '/etc/letsencrypt/live/letsencrypt-test1.example.com/privkey.pem'
          ssl_cert:             '/etc/letsencrypt/live/letsencrypt-test1.example.com/fullchain.pem'

    letsencrypt::email: 'email@example.com'
    letsencrypt::agree_tos: true
    letsencrypt::firstrun_webroot: '/usr/share/nginx/html'
    letsencrypt::nginx_vhosts:
      'letsencrypt-test1.example.com': {}


## Usage

TODO

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

TODO

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

### Class: letsencrypt

Let's Encrypt base configuration and hiera interface.

#### Parameters

[*email*]
  Required, email-address for registration and key recovery

[*agree_tos*]
  Required true,  Please read the Terms of Service at
  https://letsencrypt.org/documents/LE-SA-v1.0.1-July-27-2015.pdf.
  You must agree in order to register with the ACME
  server at https://acme-v01.api.letsencrypt.org/directory

[*server*]
  ACME Server, defaults to staging instance. For Production use
  set it to 'https://acme-v01.api.letsencrypt.org/directory'

[*webroot*]
  This directory is configured as webroot for the webroot authentication
  locations added to the vhost to allow renewals

[*firstrun_webroot*]
  Use different webroot on first run.
  Set this to the default webroot of the webserver if the service
  starts automatically when installed.
  E.g. Nginx on Ubuntu: /usr/share/nginx/html

[*firstrun_standalone*]
  Use standalone mode on first run.
  Set this to true if the webserver does not start automatically when installed.
  letsencrypt will use standalone mode to get the certificate
  before the webserver is started the first time.

[*rsa_key_size*], [*work_dir*], [*logs_dir*],
  Configruation options for letsencrypt cli.ini

[*nginx_locations*], [*nginx_vhosts*], [*exec_standalone*], [*exec_webroot*]
  These Parameters can be used to create instances of these defined types through hiera

## Limitations

Currently I only did basic testing on Ubuntu with the above hiera configuration

## Development

Run `bundle exec rake` to execute the spec tests. There are already some basic tests for each class and define, but not all options are covered.

## Release Notes

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.

## Contributors

* Philipp Gassmann <phiphi@phiphi.ch>

## TODO & Planned

* More Documentation
* More Testing
* Other install method
* Native ruby provider to get certificate? (https://github.com/unixcharles/acme-client)
* Automatically configure SSL certificate and key on the vhost
* Renewal management
* Add Domains to existing Certificates
* Fix Firstrun mode Success
* Support for Apache
* Support for RedHat, CentOS etc.
