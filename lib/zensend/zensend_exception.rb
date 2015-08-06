module ZenSend
  class ZenSendException < Exception
    attr_reader :failcode, :parameter, :http_code, :cost_in_pence, :new_balance_in_pence

    def initialize(http_code, failcode, parameter, cost_in_pence, new_balance_in_pence)
      @http_code = http_code
      @failcode = failcode
      @parameter = parameter
      @cost_in_pence = cost_in_pence
      @new_balance_in_pence = new_balance_in_pence
    end
  end
end