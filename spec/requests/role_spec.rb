require 'spec_helper'

describe '/roles' do
  subject { page }

  describe 'create a role' do
    let(:user) { create(:user)}

    before {
      sign_in_as_member(user)

      visit '/roles/new'
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

      visit "/roles/#{role.id}/edit"
      fill_in 'Name',        with: 'name changed'
      fill_in 'Description', with: 'description changed'
      click_button 'Update Role'
    }

    it { expect(page).to have_content('name changed') }
    it { expect(page).to have_content('description changed') }
  end

  describe 'delete a role' do
    let(:user) { create(:user)}
    let(:role) { create(:role) }

    before {
      sign_in_as_member(user)
      visit "/roles/#{role.id}"
    }

    it { expect { click_link 'Destroy' }.to change { Role.count }.by(-1) }
  end
end
