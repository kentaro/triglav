require 'spec_helper'

describe UserContext, env: :development do
  describe '#create' do
    context 'when user will be successfully created' do
      let(:user) { build(:user) }
      let(:context) { UserContext.new(user: user) }

      before {
        context.create
      }

      it {
        activity = Activity.first

        expect(activity).to be_true
        expect(activity.user).to eq(user)
        expect(activity.model).to eq(user)
        expect(activity.tag).to eq('create')

        expect(user.member).to be_true
      }
    end

    context 'when user will fail to be created' do
      let(:user) { build(:user, uid: nil) }
      let(:context) { UserContext.new(user: user) }

      it {
        expect(context.create).to be_false
      }

      it {
        context.create

        expect(user.member).to be_false
      }
    end
  end
end
