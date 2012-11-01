def auth_params_for (user)
  {
    "uid"      => user.uid,
    "provider" => user.provider,
    "info"     => {
      "nickname" => user.name
    },
    "extra"    => {
      "raw_info" => {
        "avatar_url" => user.image
      }
    },
    "credentials" => {
      "token" => user.access_token,
    },
  }
end

def sign_in (user)
  OmniAuth.config.mock_auth[:github] = auth_params_for(user)
  visit signin_path
end

def sign_in_as_member (user)
  SessionContext.any_instance.stub(:organizations).and_return([{ "login" => "triglav-developers" }])
  sign_in(user)
end

def sign_out
  visit root_path
  find('.navbar').click_link("Sign out")
end
