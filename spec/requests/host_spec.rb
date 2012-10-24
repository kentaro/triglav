require 'spec_helper'

describe '/hosts' do
  subject { page }

  describe 'create a host' do
    let(:user)     { create(:user)    }
    let!(:service) { create(:service) }
    let!(:role)    { create(:role)    }

    before {
      sign_in_as_member(user)
      visit new_host_path

      fill_in 'IP Address',  with: '192.168.0.1'
      fill_in 'Name',        with: 'app001'
      fill_in 'Description', with: 'app server 001'
      find('div[class="fields"][1]/select[1]').select(service.name)
      find('div[class="fields"][1]/select[2]').select(role.name)
    }

    it {
      expect { click_button 'Create Host' }.to change { Host.count }.by(1)
    }

    it {
      click_button 'Create Host'

      expect(current_path).to be == '/hosts/app001'
      expect(subject).to have_content 'Host was successfully created'
    }
  end

  describe 'edit a host' do
    let(:user)  { create(:user) }
    let!(:host) { create(:host, :with_relations, count: 3) }

    before {
      sign_in_as_member(user)
      visit edit_host_path(host)

      fill_in 'IP Address',  with: '192.168.1.1'
      fill_in 'Name',        with: 'changed'
      fill_in 'Description', with: 'changed'
      find('div[class="fields"][1]/select[1]').select(host.services.first.name)
      find('div[class="fields"][1]/select[2]').select(host.roles.first.name)
      uncheck 'Active'
    }

    it {
      expect { click_button 'Update Host' }.to change { Host.count }.by(0)
    }

    it {
      click_button 'Update Host'

      expect(current_path).to be == '/hosts/changed'
      expect(subject).to have_content 'Host was successfully updated'

      expect(page).to have_content('192.168.1.1')
      expect(page).to have_content('changed')
      expect(page).to have_content('changed')
      expect(page).to have_content(host.services.first.name)
      expect(page).to have_content(host.roles.first.name)
      expect(page).to have_content('Inactive')
    }
  end

  describe 'delete a host' do
    let(:user) { create(:user)}
    let(:host) { create(:host) }

    before {
      sign_in_as_member(user)
      visit host_path(host)
    }

    it {
      expect { click_link 'Destroy' }.to change { Host.without_deleted.count }.by(-1)
    }

    it {
      click_link 'Destroy'

      expect(current_path).to be == hosts_path
      expect(subject).to have_content 'Host was successfully destroyed'
    }
  end

  describe 'revert a host' do
    let(:user)  { create(:user)}
    let!(:host) { create(:host, deleted_at: Time.now) }

    before {
      sign_in_as_member(user)
      visit hosts_path
    }

    it {
      expect { click_link 'Revert' }.to change { Host.without_deleted.count }.by(1)
    }

    it {
      click_link 'Revert'

      expect(current_path).to be == hosts_path
      expect(subject).to have_content 'Host was successfully reverted'
    }
  end

  describe 'comment' do
    let(:user)  { create(:user) }
    let!(:host) { create(:host, deleted_at: nil) }

    before {
      sign_in_as_member(user)
      visit host_path(host)

      fill_in 'Content', with: 'comment'
    }

    it {
      expect { click_button 'Create Comment' }.to change { host.comments.count }.by(1)
    }

    it {
      click_button 'Create Comment'

      expect(current_path).to be == host_path(host)
      expect(subject).to have_content 'Comment was successfully added'
    }
  end
end
