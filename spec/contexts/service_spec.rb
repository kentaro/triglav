require 'spec_helper'

describe ServiceContext do
  describe '#create' do
    context 'when service will be successfully created' do
      let(:user)    { create(:user) }
      let(:service) { build(:service) }
      let(:context) { ServiceContext.new(user: user, service: service) }

      before { context.create }

      it {
        activity = Activity.first

        expect(activity).to be_true
        expect(activity.user).to be  == user
        expect(activity.model).to be == service
        expect(activity.tag).to be == 'create'
      }
    end

    context 'when service will fail to be created' do
      let(:service) { build(:service, name: nil) }
      let(:context) { ServiceContext.new(service: service) }

      it {
        expect(context.create).to be_false
        expect(service.valid?).to be_false
      }
    end
  end

  describe '#update' do
    context 'when service will be successfully updated' do
      let(:user)    { create(:user) }
      let(:service) { create(:service) }
      let(:context) { ServiceContext.new(user: user, service: service) }

      let!(:old_name) { service.name        }
      let!(:old_desc) { service.description }

      before {
        context.update(
          "name"        => 'updated',
          "description" => 'updated',
        )
      }

      it {
        activity = Activity.first

        expect(activity).to be_true
        expect(activity.user).to be  == user
        expect(activity.model).to be == service
        expect(activity.tag).to be == 'update'
        expect(activity.diff).to be == {
          'name'        => [old_name, 'updated'],
          'description' => [old_desc, 'updated'],
        }
      }
    end

    context 'when service will fail to be updated' do
      let(:service) { create(:role) }
      let(:context) { ServiceContext.new(service: service) }

      it {
        expect(context.update(name: nil)).to be_false
        expect(service.valid?).to be_false
      }
    end
  end

  describe '#destroy' do
    let(:user)    { create(:user) }
    let(:host)    { create(:host, :with_relations, count: 1) }
    let(:service) { host.services.first }
    let(:context) { ServiceContext.new(user: user, service: service) }

    before { context.destroy }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == service
      expect(activity.model.deleted?).to be_true
      expect(activity.tag).to be == 'destroy'
      expect(activity.model.host_relations).to be_blank
    }
  end

  describe '#revert' do
    let(:user)    { create(:user) }
    let(:service) { create(:service, deleted_at: Time.now) }
    let(:context) { ServiceContext.new(user: user, service: service) }

    before { context.revert }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == service
      expect(activity.model.deleted?).to be_false
      expect(activity.tag).to be == 'revert'
    }
  end
end
