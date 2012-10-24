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

    it {
      expect { click_button 'Create Role' }.to change { Role.count }.by(1)
    }

    it {
      click_button 'Create Role'

      expect(current_path).to be == '/roles/app'
      expect(subject).to have_content 'Role was successfully created'
    }
  end

  describe 'edit a role' do
    let(:user)      { create(:user) }
    let(:role)      { create(:role) }

    before {
      sign_in_as_member(user)

      visit edit_role_path(role)
      fill_in 'Name',        with: 'changed'
      fill_in 'Description', with: 'changed'
    }

    it {
      expect { click_button 'Update Role' }.to change { Role.count }.by(0)
    }

    it {
      click_button 'Update Role'

      expect(current_path).to be == '/roles/changed'
      expect(subject).to have_content 'Role was successfully updated'

      expect(page).to have_content('changed')
      expect(page).to have_content('changed')
    }
  end

  describe 'delete a role' do
    let(:user) { create(:user)}
    let(:role) { create(:role) }

    before {
      sign_in_as_member(user)
      visit role_path(role)
    }

    it {
      expect { click_link 'Destroy' }.to change { Role.without_deleted.count }.by(-1)
    }

    it {
      click_link 'Destroy'

      expect(current_path).to be == roles_path
      expect(subject).to have_content 'Role was successfully destroyed'
    }
  end

  describe 'revert a role' do
    let(:user)  { create(:user)}
    let!(:role) { create(:role, deleted_at: Time.now) }

    before {
      sign_in_as_member(user)
      visit roles_path
    }

    it {
      expect { click_link 'Revert' }.to change { Role.without_deleted.count }.by(1)
    }

    it {
      click_link 'Revert'

      expect(current_path).to be == roles_path
      expect(subject).to have_content 'Role was successfully reverted'
    }
  end

  describe 'comment' do
    let(:user)  { create(:user) }
    let!(:role) { create(:role, deleted_at: nil) }

    before {
      sign_in_as_member(user)
      visit role_path(role)

      fill_in 'Content', with: 'comment'
    }

    it {
      expect { click_button 'Create Comment' }.to change { role.comments.count }.by(1)
    }

    it {
      click_button 'Create Comment'

      expect(current_path).to be == role_path(role)
      expect(subject).to have_content 'Comment was successfully added'
    }
  end
end
