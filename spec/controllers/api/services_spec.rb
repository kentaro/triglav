require 'spec_helper'

describe Api::ServicesController do
  subject { response }

  shared_context 'with_member' do
    let(:api_token) { SecureRandom.urlsafe_base64 }
    let!(:user)     { create(:user, member: true, api_token: api_token) }
  end

  describe '#create' do
    context 'when service will be successfully created' do
      include_context 'with_member'

      it {
        api_post :create, service: { name: 'test' }
        expect(subject).to be_success
      }

      it {
        expect {
          api_post :create, service: { name: 'test' }
        }.to change { Service.count }.by(1)
      }
    end

    context 'when service will fail to be created' do
      
    end
  end
end
