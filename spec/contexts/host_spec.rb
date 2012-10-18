require 'spec_helper'

describe HostContext do
  describe '#create' do
    let(:user)    { create(:user) }
    let(:host)    { create(:host) }
    let(:context) { HostContext.new(user: user, host: host) }

    before { context.create }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == host
      expect(activity.tag).to be == 'create'
    }
  end

  describe '#update' do
    let(:user)    { create(:user) }
    let(:host)    { create(:host, :with_relations, count: 1) }
    let(:service) { host.services.first }
    let(:role)    { host.roles.first    }
    let(:new_service) { create(:service) }
    let(:new_role)    { create(:role)    }
    let(:context) { HostContext.new(user: user, host: host) }

    let!(:old_name) { host.name        }
    let!(:old_desc) { host.description }

    before {
      context.update(
        "name"        => 'updated',
        "description" => 'updated',
        "host_relations_attributes" => {
          "0" => {
            "service_id" => service.id.to_s,
            "role_id"    => role.id.to_s,
            "_destroy"   => "1",
            "id"         => host.id,
          },
          "1" => {
            "service_id" => new_service.id.to_s,
            "role_id"    => new_role.id.to_s,
            "_destroy"   => "0",
          },
          "2" => {
            "service_id" => "",
            "role_id"    => "",
            "_destroy"   => "0",
          },
        }
      )
    }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == host
      expect(activity.tag).to be == 'update'
      expect(activity.diff).to be == {
        'name'           => [old_name, 'updated'],
        'description'    => [old_desc, 'updated'],
        'host_relations' => {
          'deleted' => [
            {
              'service' => service.name,
              'role'    => role.name
            },
          ],
          'added' => [
            {
              'service' => new_service.name,
              'role'    => new_role.name
            },
          ],
        }
      }
    }
  end

  describe '#destroy' do
    let(:user)    { create(:user) }
    let(:host)    { create(:host, :with_relations, count: 1) }
    let(:context) { HostContext.new(user: user, host: host) }

    before { context.destroy }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == host
      expect(activity.model.deleted?).to be_true
      expect(activity.tag).to be == 'destroy'
      expect(activity.model.host_relations).to be_blank
    }
  end

  describe '#revert' do
    let(:user)    { create(:user) }
    let(:host)    { create(:host, deleted_at: Time.now) }
    let(:context) { HostContext.new(user: user, host: host) }

    before { context.revert }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == host
      expect(activity.model.deleted?).to be_false
      expect(activity.tag).to be == 'revert'
    }
  end
end
