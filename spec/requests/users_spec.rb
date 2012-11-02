require 'spec_helper'

describe '/users' do
  subject { page }

  describe 'update_api_token' do
    let(:user) { create(:user, api_token: SecureRandom.urlsafe_base64)  }
    let!(:original_token) { user.api_token }

    before {
      sign_in_as_member(user)

      visit '/api'
      click_button 'Update API Token'
    }

    it {
      expect(current_path).to be == '/api'
      expect(subject).to have_content 'API token was successfully updated'

      updated_user = User.find(user.id)

      expect(updated_user.api_token).to be_present
      expect(updated_user.api_token).to_not be == original_token
    }
  end
end
