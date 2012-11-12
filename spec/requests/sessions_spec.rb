require "spec_helper"

describe "Signin/Signout" do
  subject { page }

  describe "GET /" do
    context "when not logged in as a user" do
      before {
        visit "/"
      }

      it {
        expect(current_path).to be == '/caveat'
        expect(subject).to have_content 'Sign in'
      }
    end

    context 'when logged in as a user' do
      context 'and user is a member of the specified organization' do
        let(:user) { create(:user) }

        before {
          sign_in_as_member(user)
        }

        it {
          expect(current_path).to be == '/'
          expect(subject).to have_content user.name
        }
      end
    end
  end

  describe 'GET /signin' do
    context 'when logged in as a new user' do
      context 'and user is a member of the specified organization' do
        let(:user) { build(:user) }

        it {
          expect { sign_in_as_member(user) }.to change { User.count }.by(1)
        }

        it {
          sign_in_as_member(user)
          expect(current_path).to be == '/'
          expect(subject).to have_content user.name
          expect(subject).to have_content "Successfully signed in"
        }
      end

      context 'and user is a member but has invalid user info' do
        let(:user) { build(:user, name: nil) }

        it {
          expect { sign_in_as_member(user) }.to change { User.count }.by(0)
        }

        it {
          sign_in_as_member(user)
          expect(current_path).to be == '/caveat'
          expect(subject).to have_content "Some error occured when signing in"
        }
      end

      context 'and user is not a member of the specified organization' do
        let(:user) { build(:user) }

        before {
          SessionContext.any_instance.stub(:organizations).and_return([])
        }

        it {
          expect { sign_in(user) }.to change { User.count }.by(0)
        }

        it {
          sign_in(user)
          expect(current_path).to be == '/caveat'
          expect(subject).to have_content "You're not a member"
        }
      end
    end

    context 'when logged in as an existing user' do
      context 'and user is a member of the specified organization' do
        let!(:user) { create(:user) }

        it {
          expect { sign_in_as_member(user) }.to change { User.count }.by(0)
        }

        it {
          sign_in_as_member(user)
          expect(current_path).to be == '/'
          expect(subject).to have_content user.name
          expect(subject).to have_content "Successfully signed in"
        }
      end

      context 'and user is not a member of the specified organization' do
        let!(:user) { create(:user) }

        before {
          SessionContext.any_instance.stub(:organizations).and_return([])
        }

        it {
          expect { sign_in(user) }.to change { User.count }.by(0)
        }

        it {
          sign_in(user)
          expect(current_path).to be == '/caveat'
          expect(subject).to have_content "You're not a member"
        }
      end
    end

    context 'when Settings.github.organizations is blank (free member mode)' do
      context 'and user is a member of some organization' do
        context 'and Settings.github.organizations returns nil' do
          let!(:user) { create(:user) }
          before {
            Settings.github.stub(:organizations).and_return(nil)
          }

          it {
            expect { sign_in_as_member(user) }.to change { User.count }.by(0)
          }

          it {
            sign_in_as_member(user)
            expect(current_path).to be == '/'
            expect(subject).to have_content user.name
            expect(subject).to have_content "Successfully signed in"
          }
        end

        context 'and Settings.github.organizations returns empty string' do
          let!(:user) { create(:user) }
          before {
            Settings.github.stub(:organizations).and_return('')
          }

          it {
            expect { sign_in_as_member(user) }.to change { User.count }.by(0)
          }

          it {
            sign_in_as_member(user)
            expect(current_path).to be == '/'
            expect(subject).to have_content user.name
            expect(subject).to have_content "Successfully signed in"
          }
        end

        context 'and Settings.github.organizations returns empty array' do
          let!(:user) { create(:user) }
          before {
            Settings.github.stub(:organizations).and_return(nil)
          }

          it {
            expect { sign_in_as_member(user) }.to change { User.count }.by(0)
          }

          it {
            sign_in_as_member(user)
            expect(current_path).to be == '/'
            expect(subject).to have_content user.name
            expect(subject).to have_content "Successfully signed in"
          }
        end
      end

      context 'and user is not a member of any organization' do
        context 'and Settings.github.organizations returns nil' do
          let!(:user) { create(:user) }
          before {
            Settings.github.stub(:organizations).and_return(nil)
            SessionContext.any_instance.stub(:organizations).and_return([])
          }

          it {
            expect { sign_in_as_member(user) }.to change { User.count }.by(0)
          }

          it {
            sign_in_as_member(user)
            expect(current_path).to be == '/'
            expect(subject).to have_content user.name
            expect(subject).to have_content "Successfully signed in"
          }
        end

        context 'and Settings.github.organizations returns empty string' do
          let!(:user) { create(:user) }
          before {
            Settings.github.stub(:organizations).and_return('')
            SessionContext.any_instance.stub(:organizations).and_return([])
          }

          it {
            expect { sign_in_as_member(user) }.to change { User.count }.by(0)
          }

          it {
            sign_in_as_member(user)
            expect(current_path).to be == '/'
            expect(subject).to have_content user.name
            expect(subject).to have_content "Successfully signed in"
          }
        end

        context 'and Settings.github.organizations returns empty array' do
          let!(:user) { create(:user) }
          before {
            Settings.github.stub(:organizations).and_return(nil)
            SessionContext.any_instance.stub(:organizations).and_return([])
          }

          it {
            expect { sign_in_as_member(user) }.to change { User.count }.by(0)
          }

          it {
            sign_in_as_member(user)
            expect(current_path).to be == '/'
            expect(subject).to have_content user.name
            expect(subject).to have_content "Successfully signed in"
          }
        end
      end
    end
  end

  describe 'DELETE /signout' do
    context 'when logged in as a user' do
      let(:user) { create(:user) }

      before {
        sign_in_as_member(user)
        sign_out
      }

      it {
        expect(current_path).to be == '/caveat'
        expect(subject).to have_content 'Sign in'
        expect(subject).to have_content 'Successfully signed out'
      }
    end
  end
end
