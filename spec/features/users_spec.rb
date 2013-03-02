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

  context 'development environment', env: :development do
    describe '/users' do
      before {
        visit new_user_path
      }

      describe '#new' do
        it {
          expect(subject).to have_field('Name')
          expect(subject).to have_field('UID')
          expect(subject).to have_button('Create User')
        }
      end

      describe '#create' do
        context 'when user will be successfully created' do
          it {
            fill_in 'Name', with: 'triglav'
            fill_in 'UID',  with: '123456'

            expect { click_button 'Create User' }.to change { User.count }.by(1)
            expect(current_path).to eq('/auth/developer')
          }
        end

        context 'when user will fail to be created' do
          before {
            User.create name: 'triglav', uid: 123456, provider: 'developer', image: '//gravatar.com/avatar/12345678901234567890123456789012'
          }

          it {
            fill_in 'Name', with: 'triglav'
            fill_in 'UID',  with: '1'

            expect { click_button 'Create User' }.to change { User.count }.by(0)
            expect(current_path).to eq(users_path)
            expect(page).to have_content('Failed to create user.')
            page.within '.error' do
              expect(page).to have_field('user[name]')
              expect(page).to have_content('has already been taken')
              expect(page).not_to have_field('user[uid]')
            end
          }

          it {
            fill_in 'Name', with: 'hyperion'
            fill_in 'UID',  with: '123456'

            expect { click_button 'Create User' }.to change { User.count }.by(0)
            expect(current_path).to eq(users_path)
            expect(page).to have_content('Failed to create user.')
            page.within '.error' do
              expect(page).to have_field('user[uid]')
              expect(page).to have_content('has already been taken in the scope of this provider')
              expect(page).not_to have_field('user[name]')
            end
          }
        end
      end
    end
  end
end
