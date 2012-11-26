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

  describe '#dummy?' do
    context 'when `Rails.env` == development', env: :development do
      context 'and service.munin_url is set' do
        include_context 'init_munin_with_service'

        it {
          expect(munin.dummy?).to be_false
        }
      end

      context 'and service.munin_url is not set' do
        include_context 'init_munin_with_service'
        before { service.munin_url = nil }

        it {
          expect(munin.dummy?).to be_true
        }
      end
    end
  end

  describe '#activated?' do
    context 'when dummy mode for develpment', env: :development do
      context 'and service.munin_url is set' do
        include_context 'init_munin_with_service'

        it {
          expect(munin.activated?).to be_true
        }
      end
    end

    context 'when normal mode' do
      context 'and service.munin_url is set' do
        include_context 'init_munin_with_service'

        it {
          expect(munin.activated?).to be_true
        }
      end

      context 'and service.munin_url is not set'do
        include_context 'init_munin_with_service'
        before { service.munin_url = nil }

        it {
          expect(munin.activated?).to be_false
        }
      end
    end
  end

  describe '#root' do
    context 'when dummy mode for development', env: :development  do
      context 'and service is set' do
        include_context 'init_munin_with_service'

        it {
          expect(munin.root).to be == URI.parse(service.munin_url)
        }
      end

      context 'and service.munin_url is not set' do
        include_context 'init_munin_with_service'
        before { service.munin_url = nil }

        it {
          expect(munin.root).to be == URI.parse(Munin::DUMMY_MUNIN_URL)
        }
      end
    end

    context 'when normal mode' do
      include_context 'init_munin_with_service'

      it {
        expect(munin.root).to be == URI.parse(service.munin_url)
      }
    end
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
    context 'when option is passed' do
      include_context 'init_munin_with_service'

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
      include_context 'init_munin_with_service'

      it {
        url = munin.graph_url_for(role: role, host: host)
        expect(url).to be == URI.parse(
          "#{service.munin_url}#{URI.escape(service.name)}/#{URI.escape(role.name)}/#{URI.escape(host.name)}/load-day.png"
        )
      }
    end

    context 'when `Rails.env` is development', env: :development do
      include_context 'init_munin_with_service'
      before { service.munin_url = nil }

      it {
        url = munin.graph_url_for(role: role, host: host)
        expect(url).to be == URI.parse(Munin::DUMMY_GRAPH_PATH)
      }
    end
  end

  describe '#find_service_that_has_munin_url_by' do
    context 'service is already set' do
      include_context 'init_munin_with_service'
      it { expect(munin.find_service_that_has_munin_url_by(host)).to be == service }
    end

    context 'service is not set' do
      include_context 'init_munin'
      it { expect(munin.find_service_that_has_munin_url_by(host)).to be == service }
    end
  end
end
