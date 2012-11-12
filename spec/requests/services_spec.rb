require 'spec_helper'

describe '/services' do
  subject { page }

  describe 'create a service' do
    context 'when service will be successfully created' do
      let(:user) { create(:user) }

      before {
        sign_in_as_member(user)

        visit new_service_path
        fill_in 'Name',        with: 'triglav'
        fill_in 'Description', with: 'Server Management Tool'
      }

      it {
        expect { click_button 'Create Service' }.to change { Service.count }.by(1)
      }

      it {
        click_button 'Create Service'

        expect(current_path).to be == '/services/triglav'
        expect(subject).to have_content 'Service was successfully created'
      }
    end

    context 'when service will fail to be created' do
      let(:user) { create(:user) }

      before {
        sign_in_as_member(user)
        visit new_service_path
      }

      it {
        expect { click_button 'Create Service' }.to change { Service.count }.by(0)
      }

      it {
        click_button 'Create Service'

        expect(current_path).to be == services_path
        expect(subject).to have_content 'Failed to create service'
      }
    end
  end

  describe 'edit a service' do
    context 'when service will be successfully updated' do
      let(:user)    { create(:user)    }
      let(:service) { create(:service) }

      before {
        sign_in_as_member(user)

        visit edit_service_path(service)
        fill_in 'Name',        with: 'changed'
        fill_in 'Description', with: 'changed'
        fill_in 'Munin URL',   with: 'http://other-munin.example.com'
      }

      it {
        expect { click_button 'Update Service' }.to change { Service.count }.by(0)
      }

      it {
        click_button 'Update Service'

        expect(current_path).to be == '/services/changed'
        expect(subject).to have_content 'Service was successfully updated'

        expect(page).to have_content('changed')
        expect(page).to have_content('changed')
        expect(page).to have_content('http://other-munin.example.com')
      }
    end

    context 'when service will fail to be updated' do
      let(:user)    { create(:user)    }
      let(:service) { create(:service) }

      before {
        sign_in_as_member(user)
        visit edit_service_path(service)
        fill_in 'Munin URL', with: 'Not a URL'
      }

      it {
        expect { click_button 'Update Service' }.to change { Service.count }.by(0)
      }

      it {
        click_button 'Update Service'

        expect(current_path).to be == service_path(service)
        expect(subject).to have_content 'Failed to update service'
      }
    end
  end

  describe 'delete a service' do
    let(:user)    { create(:user)}
    let(:service) { create(:service) }

    before {
      sign_in_as_member(user)
      visit service_path(service)
    }

    it {
      expect { click_link 'Destroy' }.to change { Service.without_deleted.count }.by(-1)
    }

    it {
      click_link 'Destroy'

      expect(current_path).to be == services_path
      expect(subject).to have_content 'Service was successfully destroyed'
    }
  end

  describe 'revert a service' do
    let(:user)     { create(:user)}
    let!(:service) { create(:service, deleted_at: Time.now) }

    before {
      sign_in_as_member(user)
      visit services_path
    }

    it {
      expect { click_link 'Revert' }.to change { Service.without_deleted.count }.by(1)
    }

    it {
      click_link 'Revert'

      expect(current_path).to be == services_path
      expect(subject).to have_content 'Service was successfully reverted'
    }
  end

  describe 'comment' do
    let(:user)     { create(:user) }
    let!(:service) { create(:service, deleted_at: nil) }

    before {
      sign_in_as_member(user)
      visit service_path(service)

      fill_in 'Content', with: 'comment'
    }

    it {
      expect { click_button 'Create Comment' }.to change { service.comments.count }.by(1)
    }

    it {
      click_button 'Create Comment'

      expect(current_path).to be == service_path(service)
      expect(subject).to have_content 'Comment was successfully added'
    }
  end
end
