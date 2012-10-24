# -*- encoding: utf-8 -*-

require 'spec_helper'

describe 'i18n' do
  subject { page }

  describe 'locale' do
    context 'when HTTP_ACCEPT_LANGUAGE is ja' do
      before {
        page.driver.header('Accept-Language', 'ja-JP, ja; q=0.8')
        visit '/'
      }

      it { expect(page).to have_content 'はいぺりおん' }
    end

    context 'when HTTP_ACCEPT_LANGUAGE is en' do
      before {
        page.driver.header('Accept-Language', 'en-US, en; q=0.8')
        visit '/'
      }

      it { expect(page).to have_content 'Hyperion' }
    end

    context 'when HTTP_ACCEPT_LANGUAGE is empty' do
      before {
        page.driver.header('Accept-Language', '')
        visit '/'
      }

      it { expect(page).to have_content 'Hyperion' }
    end

    context 'when HTTP_ACCEPT_LANGUAGE is unknown' do
      before {
        page.driver.header('Accept-Language', 'fr-FR, fr; q=0.8')
        visit '/'
      }

      it { expect(page).to have_content 'Hyperion' }
    end
  end
end
