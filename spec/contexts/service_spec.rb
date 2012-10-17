require 'spec_helper'

describe ServiceContext do
  describe '#create' do
    let(:user)    { create(:user) }
    let(:service) { create(:service) }
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

  describe '#update' do
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
end
