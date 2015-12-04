require 'spec_helper'
describe 'letsencrypt::nginx' do
  let(:facts) do
    {
      :concat_basedir            => '/var/lib/puppet/concat',
    }
  end
  let(:pre_condition) do
    "
      Exec{ path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }
      class{ 'letsencrypt':
        agree_tos => true,
        email => 'admin@example.com';
      }
      include nginx
    "
  end

  context 'with defaults for all parameters' do
    it { should contain_class('letsencrypt') }
    it { should compile.with_all_deps }
    it { should contain_nginx__resource__vhost('default').with(
      :listen_options  => 'default_server',
      :www_root        =>  '/var/lib/letsencrypt/webroot',
      :server_name     => ['default'],
    )}
    it { should contain_letsencrypt__nginx__location('default')}
  end
  #  context 'with defaults for all parameters' do
  #    let(:params) do
  #      {
  #      }
  #    end
  #  end
end
