require 'spec_helper'

describe '/api' do
  describe 'authenticate' do
    context 'when api_token is valid' do
      let(:user)    { create(:user, member: true, api_token: SecureRandom.urlsafe_base64) }
      let(:service) { create(:service) }

      before {
        visit "/api/services.json?api_token=#{user.api_token}"
      }

      it { expect(page.status_code).to be == 200 }
    end

    context 'when api_token is invalid' do
      context 'when api_token is empty' do
        let(:user)    { create(:user, member: true, api_token: SecureRandom.urlsafe_base64) }
        let(:service) { create(:service) }

        before {
          visit "/api/services.json"
        }

        it { expect(page.status_code).to be == 403 }
      end

      context 'when api_token is not same' do
        let(:user)    { create(:user, member: true, api_token: SecureRandom.urlsafe_base64) }
        let(:service) { create(:service) }

        before {
          visit "/api/services.json?api_token=foo_bar"
        }

        it { expect(page.status_code).to be == 403 }
      end
    end
  end
end
