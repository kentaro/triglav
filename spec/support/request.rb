def do_request_with_api_token(method, path, params)
  params.merge!(api_token: api_token, format: :json)
  __send__(method, path, params)
end

def api_post(path, params)
  do_request_with_api_token(:post, path, params)
end
