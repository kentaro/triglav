require 'spec_helper'

describe Comment do
  describe 'validation' do
    %w(user_id model_id).each do |column|
      describe column do
        context 'when invalid' do
          context "when #{column} is nil" do
            let(:comment) { build(:comment, column.to_sym => nil) }
            it { expect(comment.valid?).to be_false }
          end

          context "when #{column} is empty" do
            let(:comment) { build(:comment, column.to_sym => '') }
            it { expect(comment.valid?).to be_false }
          end
        end
      end
    end

    describe 'model_type' do
      context 'when invalid' do
        context 'when model_type is not permitted' do
          let(:comment) { build(:comment, model_type: 'Invalid model') }
          it { expect(comment.valid?).to be_false }
        end
      end
    end

    describe 'content' do
      context 'when invalid' do
        context 'when comment is blank' do
          let(:comment) { build(:comment, content: '') }
          it { expect(comment.valid?).to be_false }
        end

        context 'when comment is too long' do
          let(:comment) { build(:comment, content: 'a' * 256) }
          it { expect(comment.valid?).to be_false }
        end
      end
    end
  end
end
