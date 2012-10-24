require 'spec_helper'

describe Activity do
  describe 'validation' do
    %w(user_id model_id).each do |column|
      describe column do
        context 'when invalid' do
          context "when #{column} is nil" do
            let(:activity) { build(:activity, column.to_sym => nil) }
            it { expect(activity.valid?).to be_false }
          end

          context "when #{column} is empty" do
            let(:activity) { build(:activity, column.to_sym => '') }
            it { expect(activity.valid?).to be_false }
          end
        end
      end
    end

    describe 'model_type' do
      context 'when invalid' do
        context 'when model_type is not permitted' do
          let(:activity) { build(:activity, model_type: 'Invalid model') }
          it { expect(activity.valid?).to be_false }
        end
      end
    end

    describe 'tag' do
      context 'when invalid' do
        context 'when tag is not permitted' do
          let(:activity) { build(:activity, tag: 'Invalid tag') }
          it { expect(activity.valid?).to be_false }
        end
      end
    end
  end
end
