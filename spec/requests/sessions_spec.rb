require "spec_helper"

describe "Signin/Signout" do
  subject { page }

  describe "GET /" do
    context "when not logged in as a user" do
      before {
        visit "/"
      }

      it { expect(subject).to have_content "Sign in" }
    end

    context "when logged in as a user" do
      let(:user) { create(:user) }

      before {
        sign_in(user)
        visit "/"
      }

      it { expect(subject).to have_content user.name }
    end
  end

  describe "DELETE /signout" do
    context "when logged in as a user" do
      let(:user) { create(:user) }

      before {
        sign_in(user)
        sign_out
      }

      it { expect(subject).to have_content "Sign in" }
    end
  end
end
