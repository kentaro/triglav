require 'spec_helper'

describe SessionContext do
  describe '#create' do
    context 'when user signs in for the first time' do
      context 'and user is a member' do
        let(:user)    { build(:user) }
        let(:context) { SessionContext.new(user: user) }

        before {
          context.stub(:organizations).and_return([{ "login" => "triglav-developers" }])
        }

        it {
          expect { context.create(auth_params_for(user)) }.to change { User.count }.by(1)
        }

        it {
          expect { context.create(auth_params_for(user)) }.to change { Activity.count }.by(1)
        }

        it {
          context.create(auth_params_for(user))
          activity = Activity.order('created_at desc').first

          expect(activity).to be_true
          expect(activity.user).to be  == user
          expect(activity.model).to be == user
          expect(activity.tag).to be == 'create'

          expect(user.member).to be_true
          expect(user.api_token).to be_true
        }
      end

      context 'and user is not a member' do
        let(:user)    { build(:user) }
        let(:context) { SessionContext.new(user: user) }

        before {
          context.stub(:organizations).and_return([])
        }

        it {
          expect { context.create(auth_params_for(user)) }.to change { User.count }.by(0)
        }

        it {
          expect { context.create(auth_params_for(user)) }.to change { Activity.count }.by(0)
        }

        it {
          context.create(auth_params_for(user))

          expect(user.member).to be_false
          expect(user.api_token).to be_nil
        }
      end
    end

    context 'when user signs in again' do
      context 'and user is a member' do
        let(:user)    { create(:user) }
        let(:context) { SessionContext.new(user: user) }

        before {
          context.stub(:organizations).and_return([{ "login" => "triglav-developers" }])
        }

        it {
          expect { context.create(auth_params_for(user)) }.to change { Activity.count }.by(0)
        }

        it {
          context.create(auth_params_for(user))

          expect(user.member).to be_true
          expect(user.api_token).to be_true
        }
      end

      context 'and user is not a member' do
        let!(:user)   { create(:user) }
        let(:context) { SessionContext.new(user: user) }

        before {
          context.stub(:organizations).and_return([])
        }

        it {
          expect { context.create(auth_params_for(user)) }.to change { User.count }.by(0)
        }

        it {
          expect { context.create(auth_params_for(user)) }.to change { Activity.count }.by(0)
        }

        it {
          context.create(auth_params_for(user))

          expect(user.member).to be_false
          expect(user.api_token).to be_nil
        }
      end
    end

    context 'when user will fail to be created' do
      let(:user)    { build(:user) }
      let(:context) { SessionContext.new(user: user) }

      before {
        context.stub(:organizations).and_return([{ "login" => "triglav-developers" }])
      }

      it {
        auth_params = auth_params_for(user)
        auth_params['info']['nickname'] = nil

        expect(context.create(auth_params)).to be_false
        expect(user.valid?).to be_false
      }
    end
  end

  describe '#update_name' do
    let(:user)    { create(:user) }
    let(:context) { SessionContext.new(user: user) }

    before { context.update_name('updated') }
    it { expect(user.name).to be == 'updated'}
  end

  describe '#update_name' do
    let(:user)    { create(:user) }
    let(:context) { SessionContext.new(user: user) }

    before {
      context.stub(:shrink_avatar_url).and_return('updated')
      context.update_image('updated')
    }

    it { expect(user.image).to be == 'updated'}
  end

  describe "#shrink_avatar_url" do
    let(:user)    { create(:user, member: nil) }
    let(:context) { SessionContext.new(user: user) }

    let(:original_url) { "https://secure.gravatar.com/avatar/23f4d5d797a91b6d17d627b90b5a42d9?s=420&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png "}
    let(:shrinked_url) { context.shrink_avatar_url(original_url) }

    it { expect(shrinked_url).to be == "//gravatar.com/avatar/23f4d5d797a91b6d17d627b90b5a42d9" }
  end

  describe '#update_access_token' do
    let(:user)    { create(:user) }
    let(:context) { SessionContext.new(user: user) }

    before { context.update_access_token('token' => 'updated') }
    it { expect(user.access_token).to be == 'updated'}
  end

  describe "#update_privilege" do
    let(:user) { create(:user, member: nil) }
    let(:context) { SessionContext.new(user: user) }

    before {
      context.stub(:organizations).and_return([{ "login" => "triglav-developers" }])
      context.update_privilege
    }

    it { expect(user.member).to be_true }
  end

  describe "#update_api_token" do
    context 'when user is a member' do
      context 'and api_token has not been set yet' do
        let(:user)    { create(:user, member: true, api_token: nil) }
        let(:context) { SessionContext.new(user: user) }

        before {
          context.update_api_token
        }

        it { expect(user.api_token).to be_true }
      end

      context 'and api_token is already set' do
        let(:user)       { create(:user, member: true, api_token: SecureRandom.urlsafe_base64) }
        let!(:api_token) { user.api_token }
        let(:context)    { SessionContext.new(user: user) }

        before {
          context.update_api_token
        }

        it {
          expect(user.api_token).to be_true
          expect(user.api_token).to be == api_token
        }
      end
    end

    context 'when user is not a member' do
      context 'and api_token has not been set yet' do
        let(:user)    { create(:user, member: nil, api_token: nil) }
        let(:context) { SessionContext.new(user: user) }

        before {
          context.update_api_token
        }

        it { expect(user.api_token).to be_nil }
      end

      context 'and api_token is already set' do
        let(:user)       { create(:user, member: nil, api_token: SecureRandom.urlsafe_base64) }
        let!(:api_token) { user.api_token }
        let(:context)    { SessionContext.new(user: user) }

        before {
          context.update_api_token
        }

        it { expect(user.api_token).to be_nil }
      end
    end
  end

  describe '#organizations' do
    let(:user)    { create(:user) }
    let(:context) { SessionContext.new(user: user) }
    let(:orgs)    { [{ "login" => "triglav-developers" }] }

    before {
      Octokit::Client.any_instance.stub(:organizations).and_return(orgs)
    }

    it {
      expect(context.organizations).to be == orgs
    }
  end
end
