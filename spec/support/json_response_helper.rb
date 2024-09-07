module JsonResponseHelper
  def json_response
    ActiveSupport::JSON.decode(response.body)
  end
end
