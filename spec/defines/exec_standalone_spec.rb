require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'letsencrypt::exec::standalone', :type => 'define' do
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
        email     => 'admin@example.com',
        agree_tos => true,
        server    => 'https://acme-v01.api.letsencrypt.org/directory',
      }
    "
  end
  context "with default" do
    it { should compile.with_all_deps }

    it { should contain_exec('letsencrypt-exec-standalone-mydomain.example.com').with(
      :command => 'letsencrypt certonly -a standalone -d mydomain.example.com --renew-by-default --server https://acme-v01.api.letsencrypt.org/directory',
      :creates => '/etc/letsencrypt/live/mydomain.example.com/fullchain.pem',
   )}
  end
  context "with params" do
    let(:title) { 'foo.com' }
    let(:params) do
      { :domains => [ 'd1.foo.com', 'd2.bar.com'],
        :server => 'http://boulderx.example.com',
      }
    end
    it { should compile.with_all_deps }

    it { should contain_exec('letsencrypt-exec-standalone-foo.com').with(
      :command => 'letsencrypt certonly -a standalone -d d1.foo.com -d d2.bar.com --renew-by-default --server http://boulderx.example.com',
      :creates => '/etc/letsencrypt/live/d1.foo.com/fullchain.pem',
   )}
  end
end
