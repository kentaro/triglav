require 'spec_helper'
require 'munin'

shared_context 'init_munin' do
  let(:host)    { create(:host, :with_relations, count: 1) }
  let(:service) { host.services.first }
  let(:role)    { host.roles.first    }
  let(:munin)   { Munin.new()         }
end

shared_context 'init_munin_with_service' do
  include_context 'init_munin'
  before { munin.service = service }
end

describe Munin do
  describe '#service' do
    include_context 'init_munin_with_service'
    it { expect(munin.service).to be == service }
  end

  describe '#root' do
    include_context 'init_munin_with_service'
    it { expect(munin.root).to be == URI.parse(service.munin_url) }
  end

  describe '#service_url' do
    include_context 'init_munin_with_service'
    it {
      expect(munin.service_url).to be == URI.parse("#{service.munin_url}#{URI.escape(service.name)}")
    }
  end

  describe '#url_for' do
    include_context 'init_munin_with_service'

    context 'when bot role and host is passed' do
      it {
        expect(munin.url_for(role: role, host: host)).to be == URI.parse("#{service.munin_url}#{URI.escape(service.name)}/#{URI.escape(role.name)}/#{URI.escape(host.name)}")
      }
    end

    context 'when role is not passed' do
      it {
        expect(munin.url_for(host: host)).to be == URI.parse(
          "#{service.munin_url}#{URI.escape(service.name)}/#{URI.escape(role.name)}/#{URI.escape(host.name)}"
        )
      }
    end
  end

  describe '#graph_url_for' do
    include_context 'init_munin_with_service'

    context 'when option is passed' do
      it {
        url = munin.graph_url_for(
          role: role,
          host: host,
          options: { type: :cpu, span: :day }
        )

        expect(url).to be == URI.parse(
          "#{service.munin_url}#{URI.escape(service.name)}/#{URI.escape(role.name)}/#{URI.escape(host.name)}/cpu-day.png"
        )
      }
    end

    context 'when option is passed' do
      it {
        url = munin.graph_url_for(role: role, host: host)
        expect(url).to be == URI.parse(
          "#{service.munin_url}#{URI.escape(service.name)}/#{URI.escape(role.name)}/#{URI.escape(host.name)}/load-day.png"
        )
      }
    end
  end

  describe '#find_service_that_hash_munin_url_by' do
    context 'service is already set' do
      include_context 'init_munin_with_service'
      it { expect(munin.find_service_that_hash_munin_url_by(host)).to be == service }
    end

    context 'service is not set' do
      include_context 'init_munin'
      it { expect(munin.find_service_that_hash_munin_url_by(host)).to be == service }
    end
  end
end
