module Errors
  class InvalidData < StandardError
    attr_reader :contract

    def initialize(message, contract)
      @contract = contract
      super(message)
    end
  end
end
