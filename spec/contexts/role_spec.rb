require 'spec_helper'

describe RoleContext do
  describe '#create' do
    let(:user)    { create(:user) }
    let(:role)    { create(:role) }
    let(:context) { RoleContext.new(user: user, role: role) }

    before { context.create }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == role
      expect(activity.tag).to be == 'role.create'
    }
  end

  describe '#update' do
    let(:user)    { create(:user) }
    let(:role)    { create(:role) }
    let(:context) { RoleContext.new(user: user, role: role) }

    let!(:old_name) { role.name        }
    let!(:old_desc) { role.description }

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
      expect(activity.model).to be == role
      expect(activity.tag).to be == 'role.update'
      expect(activity.diff).to be == {
        'name'        => [old_name, 'updated'],
        'description' => [old_desc, 'updated'],
      }
    }
  end

  describe '#destroy' do
    let(:user)    { create(:user) }
    let(:role) { create(:role) }
    let(:context) { RoleContext.new(user: user, role: role) }

    before { context.destroy }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == role
      expect(activity.model.deleted?).to be_true
      expect(activity.tag).to be == 'role.destroy'
    }
  end
end
