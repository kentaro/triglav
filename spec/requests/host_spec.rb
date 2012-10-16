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

    it { expect { click_button 'Create Host' }.to change { Host.count }.by(1) }
  end

  describe 'edit a host' do
    let(:user) { create(:user) }
    let(:host) { create(:host, :with_relations, count: 3) }

    before {
      sign_in_as_member(user)
      visit edit_host_path(host)

      fill_in 'IP Address',  with: '192.168.1.1'
      fill_in 'Name',        with: 'name changed'
      fill_in 'Description', with: 'description changed'
      find('div[class="fields"][1]/select[1]').select(host.services.first.name)
      find('div[class="fields"][1]/select[2]').select(host.roles.first.name)

      click_button 'Update Host'
    }

    it {
      expect(page).to have_content('192.168.1.1')
      expect(page).to have_content('name changed')
      expect(page).to have_content('description changed')
      expect(page).to have_content(host.services.first.name)
      expect(page).to have_content(host.roles.first.name)
    }
  end

  describe 'delete a host' do
    let(:user) { create(:user)}
    let(:host) { create(:host) }

    before {
      sign_in_as_member(user)
      visit host_path(host)
    }

    it { expect { click_link 'Destroy' }.to change { Host.without_deleted.count }.by(-1) }
  end
end
