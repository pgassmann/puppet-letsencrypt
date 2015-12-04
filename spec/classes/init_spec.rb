require 'spec_helper'
describe 'letsencrypt' do

  context 'with defaults for all parameters' do
    # fail email missing
  end
  context 'with params' do
    let(:params) do
      {
        :agree_tos => true,
        :email => 'admin@example.com',
      }
    end
    it { should compile.with_all_deps }
  end
  context 'with resources' do

    let(:facts) do
      {
        :concat_basedir            => '/var/lib/puppet/concat',
      }
    end
    let(:pre_condition) do
      "
        Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }
        include nginx
        nginx::resource::vhost{'mydomain.example.com':
          server_name => [
                    'mydomain.example.com',
                    'www.mydomain.example.com',
                    'mydomain2.example.com',
          ],
          proxy                => 'http://10.1.2.3',
          ipv6_enable          => true,
          ipv6_listen_options  => '',
          ssl                  => true,
          rewrite_to_https     => true,
          ssl_key              => '/etc/letsencrypt/live/mydomain.example.com/privkey.pem',
          ssl_cert             => '/etc/letsencrypt/live/mydomain.example.com/fullchain.pem',
        }
      "
    end
    let(:params) do
      {
        :firstrun_standalone => false,
        :agree_tos => true,
        :email => 'admin@example.com',
        :nginx_vhosts => {
          'mydomain.example.com' => {},
        },
        :nginx_locations => {
          'default' => {},
        },
        :exec_standalone => {
          'foo.com' => {},
        },
        :exec_webroot => {
          'bar.com' => {},
        },
      }
    end
    it { should compile.with_all_deps }
  end
end
