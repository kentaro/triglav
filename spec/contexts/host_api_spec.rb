require 'spec_helper'

describe HostApiContext do
  describe '#index' do
    let!(:host1)  { create(:host, :with_relations, count: 2) }
    let!(:host2)  { create(:host, :with_relations, count: 2) }
    let(:context) { HostApiContext.new }


    it {
      hosts = context.index
      expect(hosts.count).to be == 2
    }
  end
end
