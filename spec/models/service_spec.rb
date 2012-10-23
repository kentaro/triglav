require 'spec_helper'

describe Service do
  describe '#munin_url_for_service' do
    let(:service) { create(:service) }

    it {
      expect(service.munin_url_for_service).to be_a_kind_of URI
      expect(service.munin_url_for_service.to_s).to be == service.munin_url << URI.escape(service.name)
    }
  end

  describe '#munin_url_for_service_and' do
    let(:host)    { create(:host, :with_relations, count: 3) }
    let(:service) { host.services.first }

    it {
      expect(service.munin_url_for_service_and(host)).to be_a_kind_of URI
      expect(service.munin_url_for_service_and(host).to_s).to be == service.munin_url << [service.name, host.name].map { |n| URI.escape(n) }.join('/')
    }
  end

  describe '#munin_url_for_graph_of' do
    let(:host)    { create(:host, :with_relations, count: 3) }
    let(:service) { host.services.first }

    it {
      expect(service.munin_url_for_graph_of(host)).to be_a_kind_of URI
      expect(service.munin_url_for_graph_of(host).to_s).to be == service.munin_url << [service.name, host.name, 'load-day.png'].map { |n| URI.escape(n) }.join('/')
    }
  end
end
