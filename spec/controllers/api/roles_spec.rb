require 'spec_helper'

describe Api::RolesController do
  subject { response }

  describe '#index' do
    context 'when roles will be successfully shown' do
      include_context 'with_member'
      before { api_get :index }

      it {
        expect(subject).to be_success
      }
    end

    context 'when roles will fail to be shown' do
      include_context 'without_member'
      before { api_get :index }

      it {
        expect(subject.code).to be == '403'
      }
    end
  end

  describe '#show' do
    let!(:role) { create(:role) }

    context 'when role will be successfully shown' do
      include_context 'with_member'
      before { api_get :show, id: role.name }

      it {
        expect(subject).to be_success
        expect(assigns(:role)).to be == role
      }
    end

    context 'when role will fail to be shown' do
      include_context 'without_member'
      before { api_get :show, id: role.name }

      it {
        expect(subject.code).to be == '403'
        expect(assigns(:role)).to be_nil
      }
    end
  end

  describe '#create' do
    context 'when role will be successfully created' do
      include_context 'with_member'

      it {
        api_post :create, role: { name: 'test' }
        expect(subject).to be_success
        expect(assigns(:role)).to be_true
      }

      it {
        expect {
          api_post :create, role: { name: 'test' }
        }.to change { Role.count }.by(1)
      }
    end

    context 'when role will fail to be created' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'

        it {
          api_post :create, role: { name: 'test' }
          expect(subject.code).to be == '403'
          expect(assigns(:role)).to be_nil
        }

        it {
          expect {
            api_post :create, role: { name: 'test' }
          }.to change { Role.count }.by(0)
        }
      end

      context 'because request parameters are invalid' do
        include_context 'with_member'

        it {
          api_post :create, role: { name: 'x' * 256 } # too long
          expect(subject.code).to be == '422'
          expect(assigns(:role)).to be_true
        }

        it {
          expect {
            api_post :create, role: { name: 'x' * 256 } # too long
          }.to change { Role.count }.by(0)
        }
      end
    end
  end

  describe '#update' do
    context 'when role will be successfully updated' do
      include_context 'with_member'
      let!(:role) { create(:role) }

      it {
        api_post :update, id: role.name, role: { name: 'test' }
        expect(subject).to be_success
        expect(assigns(:role)).to_not be role
      }

      it {
        expect {
          api_post :update, id: role.name, role: { name: 'test' }
        }.to change { Role.count }.by(0)
      }
    end

    context 'when role will fail to be updated' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'
        let!(:role) { create(:role) }

        it {
          api_post :update, id: role.name, role: { name: 'test' }
          expect(subject.code).to be == '403'
          expect(assigns(:role)).to be_nil
        }

        it {
          expect {
            api_post :update, id: role.name, role: { name: 'test'  }
          }.to change { Role.count }.by(0)
        }
      end

      context 'because request parameters are invalid' do
        include_context 'with_member'
        let!(:role) { create(:role) }

        it {
          api_post :update, id: role.name, role: { name: '' * 256 } # too long
          expect(subject.code).to be == '422'
          expect(assigns(:role)).to be == role
        }

        it {
          expect {
            api_post :update, id: role.name, role: { name: '' * 256 } # too long
          }.to change { Role.count }.by(0)
        }
      end
    end
  end

  describe '#destroy' do
    context 'when role will be successfully destroyed' do
      include_context 'with_member'
      let!(:role) { create(:role) }

      it {
        api_post :destroy, id: role.name
        expect(subject).to be_success
        expect(assigns(:role)).to_not be role
      }

      it {
        expect {
          api_post :destroy, id: role.name
        }.to change { Role.without_deleted.count }.by(-1)
      }
    end

    context 'when role will fail to be destroyed' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'
        let!(:role) { create(:role) }

        it {
          api_post :destroy, id: role.name
          expect(subject.code).to be == '403'
          expect(assigns(:role)).to be_nil
        }

        it {
          expect {
            api_post :destroy, id: role.name
          }.to change { Role.without_deleted.count }.by(0)
        }
      end
    end
  end

  describe '#revert' do
    context 'when role will be successfully reverted' do
      include_context 'with_member'
      let!(:role) { create(:role, deleted_at: Time.now) }

      it {
        api_post :revert, id: role.name
        expect(subject).to be_success
        expect(assigns(:role)).to_not be role
      }

      it {
        expect {
          api_post :revert, id: role.name
        }.to change { Role.without_deleted.count }.by(1)
      }
    end

    context 'when role will fail to be reverted' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'
        let!(:role) { create(:role, deleted_at: Time.now) }

        it {
          api_post :revert, id: role.name
          expect(subject.code).to be == '403'
          expect(assigns(:role)).to be_nil
        }

        it {
          expect {
            api_post :revert, id: role.name
          }.to change { Role.without_deleted.count }.by(0)
        }
      end
    end
  end

  describe '#require_role' do
    let!(:role) { create(:role) }

    context 'when role is found' do
      include_context 'with_member'
      before { api_get :show, id: role.name }

      it {
        expect(assigns(:role)).to be == role
      }
    end

    context 'when role is not found' do
      include_context 'with_member'
      before { api_get :show, id: role.name + (2**32).to_s } # impossible name

      it {
        expect(subject.code).to be == "404"
      }
    end
  end

  describe '#bad_request' do
    context 'when request is bad' do
      include_context 'with_member'
      before { api_post :create }

      it {
        expect(subject.code).to be == "400"
      }
    end
  end
end
