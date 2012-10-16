require 'spec_helper'

describe '/hosts' do
  subject { page }

  describe 'create a host' do
    let(:user) { create(:user)}

    before {
      sign_in_as_member(user)

      visit new_host_path
      fill_in 'IP Address',  with: '192.168.0.1'
      fill_in 'Name',        with: 'app001'
      fill_in 'Description', with: 'app server 001'
    }

    it { expect { click_button 'Create Host' }.to change { Host.count }.by(1) }
  end

  describe 'edit a host' do
    let(:user) { create(:user) }
    let(:host) { create(:host) }

    before {
      sign_in_as_member(user)

      visit edit_host_path(host)
      fill_in 'IP Address',  with: '192.168.1.1'
      fill_in 'Name',        with: 'name changed'
      fill_in 'Description', with: 'description changed'
      click_button 'Update Host'
    }

    it { expect(page).to have_content('192.168.1.1') }
    it { expect(page).to have_content('name changed') }
    it { expect(page).to have_content('description changed') }
  end

  describe 'delete a host' do
    let(:user) { create(:user)}
    let(:host) { create(:host) }

    before {
      sign_in_as_member(user)
      visit host_path(host)
    }

    it { expect { click_link 'Destroy' }.to change { Host.count }.by(-1) }
  end
end
