require 'spec_helper'

describe Api::ServicesController do
  subject { response }

  describe '#index' do
    context 'when services will be successfully shown' do
      include_context 'with_member'
      before { api_get :index }

      it {
        expect(subject).to be_success
      }
    end

    context 'when services will fail to be shown' do
      include_context 'without_member'
      before { api_get :index }

      it {
        expect(subject.code).to be == '403'
      }
    end
  end

  describe '#show' do
    let!(:service) { create(:service) }

    context 'when service will be successfully shown' do
      include_context 'with_member'
      before { api_get :show, id: service.name }

      it {
        expect(subject).to be_success
        expect(assigns(:service)).to be == service
      }
    end

    context 'when service will fail to be shown' do
      include_context 'without_member'
      before { api_get :show, id: service.name }

      it {
        expect(subject.code).to be == '403'
        expect(assigns(:service)).to be_nil
      }
    end
  end

  describe '#create' do
    context 'when service will be successfully created' do
      include_context 'with_member'

      it {
        api_post :create, service: { name: 'test' }
        expect(subject).to be_success
        expect(assigns(:service)).to be_true
      }

      it {
        expect {
          api_post :create, service: { name: 'test' }
        }.to change { Service.count }.by(1)
      }
    end

    context 'when service will fail to be created' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'

        it {
          api_post :create, service: { name: 'test' }
          expect(subject.code).to be == '403'
          expect(assigns(:service)).to be_nil
        }

        it {
          expect {
            api_post :create, service: { name: 'test' }
          }.to change { Service.count }.by(0)
        }
      end

      context 'because request parameters are invalid' do
        include_context 'with_member'

        it {
          api_post :create, service: { name: 'x' * 256 } # too long
          expect(subject.code).to be == '422'
          expect(assigns(:service)).to be_true
        }

        it {
          expect {
            api_post :create, service: { name: 'x' * 256 } # too long
          }.to change { Service.count }.by(0)
        }
      end
    end
  end

  describe '#update' do
    context 'when service will be successfully updated' do
      include_context 'with_member'
      let!(:service) { create(:service) }

      it {
        api_post :update, id: service.name, service: { name: 'test' }
        expect(subject).to be_success
        expect(assigns(:service)).to_not be service
      }

      it {
        expect {
          api_post :update, id: service.name, service: { name: 'test' }
        }.to change { Service.count }.by(0)
      }
    end

    context 'when service will fail to be updated' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'
        let!(:service) { create(:service) }

        it {
          api_post :update, id: service.name, service: { name: 'test' }
          expect(subject.code).to be == '403'
          expect(assigns(:service)).to be_nil
        }

        it {
          expect {
            api_post :update, id: service.name, service: { name: 'test'  }
          }.to change { Service.count }.by(0)
        }
      end

      context 'because request parameters are invalid' do
        include_context 'with_member'
        let!(:service) { create(:service) }

        it {
          api_post :update, id: service.name, service: { name: '' * 256 } # too long
          expect(subject.code).to be == '422'
          expect(assigns(:service)).to be == service
        }

        it {
          expect {
            api_post :update, id: service.name, service: { name: '' * 256 } # too long
          }.to change { Service.count }.by(0)
        }
      end
    end
  end

  describe '#destroy' do
    context 'when service will be successfully destroyed' do
      include_context 'with_member'
      let!(:service) { create(:service) }

      it {
        api_post :destroy, id: service.name
        expect(subject).to be_success
        expect(assigns(:service)).to_not be service
      }

      it {
        expect {
          api_post :destroy, id: service.name
        }.to change { Service.without_deleted.count }.by(-1)
      }
    end

    context 'when service will fail to be destroyed' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'
        let!(:service) { create(:service) }

        it {
          api_post :destroy, id: service.name
          expect(subject.code).to be == '403'
          expect(assigns(:service)).to be_nil
        }

        it {
          expect {
            api_post :destroy, id: service.name
          }.to change { Service.without_deleted.count }.by(0)
        }
      end
    end
  end

  describe '#revert' do
    context 'when service will be successfully reverted' do
      include_context 'with_member'
      let!(:service) { create(:service, deleted_at: Time.now) }

      it {
        api_post :revert, id: service.name
        expect(subject).to be_success
        expect(assigns(:service)).to_not be service
      }

      it {
        expect {
          api_post :revert, id: service.name
        }.to change { Service.without_deleted.count }.by(1)
      }
    end

    context 'when service will fail to be reverted' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'
        let!(:service) { create(:service, deleted_at: Time.now) }

        it {
          api_post :revert, id: service.name
          expect(subject.code).to be == '403'
          expect(assigns(:service)).to be_nil
        }

        it {
          expect {
            api_post :revert, id: service.name
          }.to change { Service.without_deleted.count }.by(0)
        }
      end
    end
  end

  describe '#require_service' do
    let!(:service) { create(:service) }

    context 'when service is found' do
      include_context 'with_member'
      before { api_get :show, id: service.name }

      it {
        expect(assigns(:service)).to be == service
      }
    end

    context 'when service is not found' do
      include_context 'with_member'
      before { api_get :show, id: service.name + (2**32).to_s } # impossible name

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
