require 'spec_helper'
describe 'letsencrypt' do

  context 'with defaults for all parameters' do
    # fail email missing
  end
  context 'with params' do
    let(:params) do
      {
        :email => 'admin@example.com',
      }
    end
    it { should compile.with_all_deps }
  end
end
