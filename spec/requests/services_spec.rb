require 'spec_helper'

describe '/services' do
  subject { page }

  describe 'create a service' do
    let(:user) { create(:user)}

    before {
      sign_in_as_member(user)

      visit new_service_path
      fill_in 'Name',        with: 'Hyperion'
      fill_in 'Description', with: 'Server Management Tool'
    }

    it { expect { click_button 'Create Service' }.to change { Service.count }.by(1) }
  end

  describe 'edit a service' do
    let(:user)         { create(:user)    }
    let(:service)      { create(:service) }

    before {
      sign_in_as_member(user)

      visit edit_service_path(service)
      fill_in 'Name',        with: 'name changed'
      fill_in 'Description', with: 'description changed'
      click_button 'Update Service'
    }

    it {
      expect(page).to have_content('name changed')
      expect(page).to have_content('description changed')
    }
  end

  describe 'delete a service' do
    let(:user)    { create(:user)}
    let(:service) { create(:service) }

    before {
      sign_in_as_member(user)
      visit service_path(service)
    }

    it { expect { click_link 'Destroy' }.to change { Service.count }.by(-1) }
  end
end
