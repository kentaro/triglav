require 'spec_helper'

describe RoleContext do
  describe '#create' do
    context 'when role will be successfully created' do
      let(:user)    { create(:user) }
      let(:role)    { build(:role)  }
      let(:context) { RoleContext.new(user: user, role: role) }

      before { context.create }

      it {
        activity = Activity.first

        expect(activity).to be_true
        expect(activity.user).to be  == user
        expect(activity.model).to be == role
        expect(activity.tag).to be == 'create'
      }
    end

    context 'when role will fail to be created' do
      let(:role)    { build(:role, name: nil)     }
      let(:context) { RoleContext.new(role: role) }

      it {
        expect(context.create).to be_false
        expect(role.valid?).to be_false
      }
    end
  end

  describe '#update' do
    context 'when role will be successfully updated' do
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
        expect(activity.tag).to be == 'update'
        expect(activity.diff).to be == {
          'name'        => [old_name, 'updated'],
          'description' => [old_desc, 'updated'],
        }
      }
    end

    context 'when role will fail to be updated' do
      let(:role)    { create(:role) }
      let(:context) { RoleContext.new(role: role) }

      it {
        expect(context.update(name: nil)).to be_false
        expect(role.valid?).to be_false
      }
    end
  end

  describe '#destroy' do
    let(:user)    { create(:user) }
    let(:host)    { create(:host, :with_relations, count: 1) }
    let(:role)    { host.roles.first }
    let(:context) { RoleContext.new(user: user, role: role) }

    before { context.destroy }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == role
      expect(activity.model.deleted?).to be_true
      expect(activity.tag).to be == 'destroy'
      expect(activity.model.host_relations).to be_blank
    }
  end

  describe '#revert' do
    let(:user)    { create(:user) }
    let(:role)    { create(:role, deleted_at: Time.now) }
    let(:context) { RoleContext.new(user: user, role: role) }

    before { context.revert }

    it {
      activity = Activity.first

      expect(activity).to be_true
      expect(activity.user).to be  == user
      expect(activity.model).to be == role
      expect(activity.model.deleted?).to be_false
      expect(activity.tag).to be == 'revert'
    }
  end
end
