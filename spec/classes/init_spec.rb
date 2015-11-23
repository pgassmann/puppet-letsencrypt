require 'spec_helper'
describe 'letsencrypt' do

  context 'with defaults for all parameters' do
    # fail email missing
  end
  context 'with defaults for all parameters' do
    let(:params) do
      {
        :email => 'admin@example.com',
      }
    end
    it { should contain_class('letsencrypt') }
    it { should compile.with_all_deps }
  end
end
