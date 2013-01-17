require 'spec_helper'

describe Api::HostsController do
  subject { response }

  describe '#index' do
    context 'when hosts will be successfully shown' do
      include_context 'with_member'
      before { api_get :index }

      it {
        expect(subject).to be_success
      }
    end

    context 'when hosts will fail to be shown' do
      include_context 'without_member'
      before { api_get :index }

      it {
        expect(subject.code).to be == '403'
      }
    end
  end

  describe '#show' do
    let!(:host) { create(:host) }

    context 'when host will be successfully shown' do
      include_context 'with_member'
      before { api_get :show, id: host.name }

      it {
        expect(subject).to be_success
        expect(assigns(:host)).to be == host
      }
    end

    context 'when host will fail to be shown' do
      include_context 'without_member'
      before { api_get :show, id: host.name }

      it {
        expect(subject.code).to be == '403'
        expect(assigns(:host)).to be_nil
      }
    end
  end

  describe '#create' do
    context 'when host will be successfully created' do
      include_context 'with_member'

      it {
        api_post :create, host: { name: 'test' }
        expect(subject).to be_success
        expect(assigns(:host)).to be_true
      }

      it {
        expect {
          api_post :create, host: { name: 'test' }
        }.to change { Host.count }.by(1)
      }
    end

    context 'when host will fail to be created' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'

        it {
          api_post :create, host: { name: 'test' }
          expect(subject.code).to be == '403'
          expect(assigns(:host)).to be_nil
        }

        it {
          expect {
            api_post :create, host: { name: 'test' }
          }.to change { Host.count }.by(0)
        }
      end

      context 'because request parameters are invalid' do
        include_context 'with_member'

        it {
          api_post :create, host: { name: 'x' * 256 } # too long
          expect(subject.code).to be == '422'
          expect(assigns(:host)).to be_true
        }

        it {
          expect {
            api_post :create, host: { name: 'x' * 256 } # too long
          }.to change { Host.count }.by(0)
        }
      end
    end
  end

  describe '#update' do
    context 'when host will be successfully updated' do
      include_context 'with_member'
      let!(:host) { create(:host) }

      it {
        api_post :update, id: host.name, host: { name: 'test' }
        expect(subject).to be_success
        expect(assigns(:host)).to_not be host
      }

      it {
        expect {
          api_post :update, id: host.name, host: { name: 'test' }
        }.to change { Host.count }.by(0)
      }
    end

    context 'when host will fail to be updated' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'
        let!(:host) { create(:host) }

        it {
          api_post :update, id: host.name, host: { name: 'test' }
          expect(subject.code).to be == '403'
          expect(assigns(:host)).to be_nil
        }

        it {
          expect {
            api_post :update, id: host.name, host: { name: 'test'  }
          }.to change { Host.count }.by(0)
        }
      end

      context 'because request parameters are invalid' do
        include_context 'with_member'
        let!(:host) { create(:host) }

        it {
          api_post :update, id: host.name, host: { name: '' * 256 } # too long
          expect(subject.code).to be == '422'
          expect(assigns(:host)).to be == host
        }

        it {
          expect {
            api_post :update, id: host.name, host: { name: '' * 256 } # too long
          }.to change { Host.count }.by(0)
        }
      end
    end
  end

  describe '#update (with relation)' do
    context 'when relation will be successfully created' do
      include_context 'with_member'
      let!(:service) { create(:service) }
      let!(:role)    { create(:role)    }
      let!(:host)    { create(:host)    }

      it {
        expect {
          api_post :update, id: host.name, host: {
            host_relations_attributes: [
              {
                service_id: service.id,
                role_id:    role.id,
              }
            ]
          }
        }.to change { HostRelation.count }.by(1)
      }
    end

    context 'when relation will be successfully updated' do
      include_context 'with_member'
      let!(:host)    { create(:host, :with_relations, count: 1) }
      let!(:service) { create(:service) }

      it {
        api_post :update, id: host.name, host: {
          host_relations_attributes: [
            {
              id:         host.host_relations.first.id,
              service_id: service.id,
              role_id:    host.host_relations.first.role_id,
            }
          ]
        }
        expect(assigns(:host).host_relations.first.service_id).to be == service.id
      }

      it {
        expect {
          api_post :update, id: host.name, host: {
            host_relations_attributes: [
              {
                id:         host.host_relations.first.id,
                service_id: service.id,
                role_id:    host.host_relations.first.role_id,
              }
            ]
          }
        }.to change { HostRelation.count }.by(0)
      }
    end

    context 'when relation will be successfully destroyed' do
      include_context 'with_member'
      let!(:host) { create(:host, :with_relations, count: 1) }

      it {
        expect {
          api_post :update, id: host.name, host: {
            host_relations_attributes: [
              {
                id:         host.host_relations.first.id,
                service_id: host.host_relations.first.service_id,
                role_id:    host.host_relations.first.role_id,
                _destroy:   1,
              }
            ]
          }
        }.to change { HostRelation.count }.by(-1)
      }
    end
  end

  describe '#destroy' do
    context 'when host will be successfully destroyed' do
      include_context 'with_member'
      let!(:host) { create(:host) }

      it {
        api_post :destroy, id: host.name
        expect(subject).to be_success
        expect(assigns(:host)).to_not be host
      }

      it {
        expect {
          api_post :destroy, id: host.name
        }.to change { Host.without_deleted.count }.by(-1)
      }
    end

    context 'when host will fail to be destroyed' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'
        let!(:host) { create(:host) }

        it {
          api_post :destroy, id: host.name
          expect(subject.code).to be == '403'
          expect(assigns(:host)).to be_nil
        }

        it {
          expect {
            api_post :destroy, id: host.name
          }.to change { Host.without_deleted.count }.by(0)
        }
      end
    end
  end

  describe '#revert' do
    context 'when host will be successfully reverted' do
      include_context 'with_member'
      let!(:host) { create(:host, deleted_at: Time.now) }

      it {
        api_post :revert, id: host.name
        expect(subject).to be_success
        expect(assigns(:host)).to_not be host
      }

      it {
        expect {
          api_post :revert, id: host.name
        }.to change { Host.without_deleted.count }.by(1)
      }
    end

    context 'when host will fail to be reverted' do
      context 'because appropriate member do not exist' do
        include_context 'without_member'
        let!(:host) { create(:host, deleted_at: Time.now) }

        it {
          api_post :revert, id: host.name
          expect(subject.code).to be == '403'
          expect(assigns(:host)).to be_nil
        }

        it {
          expect {
            api_post :revert, id: host.name
          }.to change { Host.without_deleted.count }.by(0)
        }
      end
    end
  end

  describe '#require_host' do
    let!(:host) { create(:host) }

    context 'when host is found' do
      include_context 'with_member'
      before { api_get :show, id: host.name }

      it {
        expect(assigns(:host)).to be == host
      }
    end

    context 'when host is not found' do
      include_context 'with_member'
      before { api_get :show, id: host.name + (2**32).to_s } # impossible name

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
