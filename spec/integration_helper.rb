require 'rails_helper'
require 'swagger_helper'

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request

  config.include JsonResponseHelper, type: :request

  config.extend SpecExampleMetaHelper, type: :request
end
