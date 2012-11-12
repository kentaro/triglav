require 'spec_helper'

describe CommentContext do
  describe '#create' do
    %w(service role host).map(&:to_sym).each do |model|
      context 'comment will be succesfully saved' do
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

      context 'comment will be failed to be saved' do
        let(:user)    { create(:user) }
        let(:parent)  { create(model) }
        let(:comment) { parent.comments.build(content: 'a' * 256) }
        let(:context) { CommentContext.new(user: user, comment: comment) }

        it {
          expect(context.create).to be_false
          expect(comment.valid?).to be_false
        }
      end
    end
  end
end
