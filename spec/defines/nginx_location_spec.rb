require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'letsencrypt::nginx::location', :type => 'define' do
  let(:facts) do
    {
      :concat_basedir            => '/var/lib/puppet/concat',
    }
  end
  let(:title) { 'mydomain.example.com' }
  let(:pre_condition) do
    "
      Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }
      class{ 'letsencrypt':
        agree_tos => true,
        email => 'admin@example.com';
      }
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
  context "with default" do
    it { should compile.with_all_deps }
    it { should contain_nginx__resource__location('mydomain.example.com-letsencrypt').with(
      :vhost    => 'mydomain.example.com',
      :location => '/.well-known/acme-challenge',
      :www_root =>  '/var/lib/letsencrypt/webroot',
      :ssl      =>  true,
   )}
  end
end
