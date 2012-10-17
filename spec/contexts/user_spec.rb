require 'spec_helper'

describe UserContext do
  describe '#create' do
    context 'when user signs in for the first time' do
      let(:user)    { build(:user) }
      let(:context) { UserContext.new(user: user) }

      before { context.create }

      it {
        activity = Activity.first

        expect(activity).to be_true
        expect(activity.user).to be  == user
        expect(activity.model).to be == user
        expect(activity.tag).to be == 'create'
      }
    end

    context 'when user signs in again' do
      let(:user)    { create(:user) }
      let(:context) { UserContext.new(user: user) }

      before { context.create }

      it {
        activity = Activity.first
        expect(activity).to be_nil
      }
    end
  end
end
