require "spec_helper"

describe User do
  describe "User.shrink_avatar_url" do
    let(:original_url) { "https://secure.gravatar.com/avatar/23f4d5d797a91b6d17d627b90b5a42d9?s=420&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png "}
    let(:shrinked_url) { User.shrink_avatar_url(original_url) }
    subject { shrinked_url }

    it { expect(subject).to be == "//gravatar.com/avatar/23f4d5d797a91b6d17d627b90b5a42d9" }
  end

  describe "#member?" do
    context "when default" do
      let(:user) { create(:user) }
      subject { user }

      it { expect(user.member).to_not be == nil }
    end

    context "when after invoking #update_privilege" do
      let(:user) { create(:user) }
      subject { user }

      before {
        User.any_instance.stub(:organizations).and_return([{ "login" => "hyperion" }])
        user.update_privilege
      }

      it { expect(subject.member).to be == true }
    end
  end

  describe "#update_privilege" do
    let(:user)    { create(:user) }
    let!(:member) { user.member }
    subject { user }

    before {
      User.any_instance.stub(:organizations).and_return([{ "login" => "hyperion" }])
      user.update_privilege
    }

    it { expect(subject.member).to_not be == member }
  end

  describe "#update_token" do
    let(:user)   { create(:user) }
    let!(:token) { user.token }
    subject { user }

    before {
      user.update_token
    }

    it { expect(subject.token).to_not be == token }
  end
end
