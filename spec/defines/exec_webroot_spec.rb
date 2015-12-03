require File.expand_path(File.join(File.dirname(__FILE__),'../spec_helper'))

describe 'letsencrypt::exec::webroot', :type => 'define' do
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
        email => 'admin@example.com',
        firstrun_standalone => false,
      }
    "
  end
  context "with default" do
    it { should compile.with_all_deps }

    it { should contain_exec('letsencrypt-exec-webroot-mydomain.example.com').with(
      :command => 'letsencrypt certonly -a webroot --webroot-path /var/lib/letsencrypt/webroot -d mydomain.example.com --agree-dev-preview --renew-by-default --server https://acme-v01.api.letsencrypt.org/directory',
      :creates => '/etc/letsencrypt/live/mydomain.example.com/fullchain.pem',
   )}
  end
  context "with params" do
    let(:title) { 'foo.com' }
    let(:params) do
      { :domains => [ 'd1.foo.com', 'd2.bar.com'],
        :server  => 'http://boulderx.example.com',
        :webroot => '/tmp/webroot'
      }
    end
    it { should compile.with_all_deps }

    it { should contain_exec('letsencrypt-exec-webroot-foo.com').with(
      :command => 'letsencrypt certonly -a webroot --webroot-path /tmp/webroot -d d1.foo.com -d d2.bar.com --agree-dev-preview --renew-by-default --server http://boulderx.example.com',
      :creates => '/etc/letsencrypt/live/d1.foo.com/fullchain.pem',
   )}
  end
  context "with firstrun_standalone mode" do
    let(:pre_condition) do
      "
        Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }
        class{ 'letsencrypt':
          email => 'admin@example.com',
          firstrun_standalone => true,
        }
      "
    end
    let(:title) { 'foo.com' }
    let(:params) do
      { :domains => [ 'd1.foo.com', 'd2.bar.com'],
        :server  => 'http://boulderx.example.com',
        :webroot => '/tmp/webroot'
      }
    end
    it { should compile.with_all_deps }
    it { should_not contain_exec('letsencrypt-exec-webroot-foo.com')}
    it { should contain_letsencrypt__exec__standalone('foo.com').with(
      :domains => [ 'd1.foo.com', 'd2.bar.com'],
      :server  => 'http://boulderx.example.com',
   )}
  end
  context "with firstrun_standalone mode" do
    let(:pre_condition) do
      "
        Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }
        class{ 'letsencrypt':
          email => 'admin@example.com',
          firstrun_standalone => true,
        }
      "
    end
    let(:facts) do
      {
        :concat_basedir            => '/var/lib/puppet/concat',
        :letsencrypt_firstrun      => 'SUCCESS'
      }
    end
    let(:title) { 'foo.com' }
    it { should compile.with_all_deps }
    it { should contain_exec('letsencrypt-exec-webroot-foo.com')}
  end
end
