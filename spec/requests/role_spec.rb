require 'spec_helper'

describe '/roles' do
  subject { page }

  describe 'create a role' do
    let(:user) { create(:user)}

    before {
      sign_in_as_member(user)

      visit new_role_path
      fill_in 'Name',        with: 'app'
      fill_in 'Description', with: 'role for app servers'
    }

    it { expect { click_button 'Create Role' }.to change { Role.count }.by(1) }
  end

  describe 'edit a role' do
    let(:user)      { create(:user) }
    let(:role)      { create(:role) }

    before {
      sign_in_as_member(user)

      visit edit_role_path(role)
      fill_in 'Name',        with: 'name changed'
      fill_in 'Description', with: 'description changed'
      click_button 'Update Role'
    }

    it {
      expect(page).to have_content('name changed')
      expect(page).to have_content('description changed')
    }
  end

  describe 'delete a role' do
    let(:user) { create(:user)}
    let(:role) { create(:role) }

    before {
      sign_in_as_member(user)
      visit role_path(role)
    }

    it { expect { click_link 'Destroy' }.to change { Role.without_deleted.count }.by(-1) }
  end
end
