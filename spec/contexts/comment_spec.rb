require 'spec_helper'

describe CommentContext do
  describe '#create' do
    %w(service host).map(&:to_sym).each do |model|
      let(:user)    { create(:user) }
      let(:parent)  { create(model) }
      let(:comment) { parent.comments.build(content: 'comment') }
      let(:context) { CommentContext.new(user: user, comment: comment) }

      before { context.create }

      it {
        activity = Activity.first

        expect(activity).to be_true
        expect(activity.user).to be  == user
        expect(activity.model).to be == comment
        expect(activity.tag).to be == 'create'
      }
    end
  end
end
