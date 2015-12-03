require 'spec_helper'
describe 'letsencrypt::install' do

  context 'with defaults for all parameters' do
    it { should compile.with_all_deps }
  end
#  context 'with params' do
#    let(:params) do
#      {
#      }
#    end
#    it { should compile.with_all_deps }
#  end
end
