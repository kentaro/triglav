require 'spec_helper'

describe HostRelation do
  describe 'validation' do
    describe 'service_id' do
      context 'when invalid' do
        %w(service_id role_id).each do |column|
          context "when #{column} is nil" do
            let(:host_relation) { build(:host_relation, column.to_sym => nil) }
            it { expect(host_relation.valid?).to be_false }
          end

          context "when #{column} is empty" do
            let(:host_relation) { build(:host_relation, column.to_sym => '') }
            it { expect(host_relation.valid?).to be_false }
          end

          context "when name is not numeric" do
            let(:host_relation) { build(:host_relation, column.to_sym => 'abced') }

            ### `*_id` becomes `0` inspite of being inserted string. Why?
            it { expect(host_relation.valid?).to be_true }
          end
        end
      end
    end
  end
end
