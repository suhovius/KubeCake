module Github
  module Webhooks
    module Handlers
    	class Base
    		def initialize(params:, header_attrs:)
    			@params = params
    			@header_attrs = header_attrs
    		end

    		def perform
    			raise NotImplementedError.new("#{self.class}##{__method__} is not implemented!")
    		end
    	end
    end
  end
end