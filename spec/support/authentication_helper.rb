module AuthenticationHelper
  def auth_header_for(token)
    "Token token=#{token}"
  end
end
