shared_context 'with_member' do
  let(:api_token) { SecureRandom.urlsafe_base64 }
  let!(:user)     { create(:user, member: true, api_token: api_token) }
end

shared_context 'without_member' do
  let(:api_token) { '' }
  let!(:user)     { create(:user, member: true, api_token: SecureRandom.urlsafe_base64) }
end

def do_request_with_api_token(method, path, params)
  params.merge!(api_token: api_token, format: :json)
  __send__(method, path, params)
end

def api_get(path, params = {})
  do_request_with_api_token(:get, path, params)
end

def api_post(path, params = {})
  do_request_with_api_token(:post, path, params)
end
