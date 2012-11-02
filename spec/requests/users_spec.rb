require 'spec_helper'

describe '/users' do
  subject { page }

  describe '#show' do
    context 'when owner accesses' do
      let(:owner) { create(:user) }

      before {
        sign_in_as_member(owner)
        visit user_path(owner)
      }

      it {
        expect(subject.status_code).to be == 200
      }
    end

    context 'when not owner accesses' do
      let(:owner) { create(:user) }
      let(:user)  { create(:user) }

      before {
        sign_in_as_member(user)
        visit user_path(owner)
      }

      it {
        expect(subject.status_code).to be == 403
      }
    end
  end

  describe '#update' do
    context 'when owner accesses' do
      let(:owner) { create(:user, api_token: SecureRandom.urlsafe_base64)  }
      let!(:original_token) { owner.api_token }

      before {
        sign_in_as_member(owner)

        visit user_path(owner)
        click_button 'Update'
      }

      it {
        expect(current_path).to be == user_path(owner)
        expect(subject).to have_content 'API token was successfully updated'

        updated_owner = User.find(owner.id)
        expect(updated_owner.api_token).to be_present
        expect(updated_owner.api_token).to_not be == original_token
      }
    end

    context 'when not owner accesses' do
      let(:owner) { create(:user, api_token: SecureRandom.urlsafe_base64)  }
      let(:user)  { create(:user) }
      let!(:original_token) { owner.api_token }

      before {
        sign_in_as_member(user)
        visit user_path(owner)
      }

      it {
        expect(subject.status_code).to be == 403

        updated_owner = User.find(owner.id)
        expect(updated_owner.api_token).to be == original_token
      }
    end
  end
end
