require 'spec_helper'

describe '/activities' do
  describe 'show activities' do
    let(:user) { create(:user)}

    before {
      sign_in_as_member(user)
      visit "/activities"
    }

    it { expect(page.status_code).to be == 200 }
  end
end
