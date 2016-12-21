module ZenSend
  CreateKeywordResponse = Struct.new(:cost_in_pence, :new_balance_in_pence)

  class CreateKeywordResponse

    def set_from_response(response_hash)
      self.cost_in_pence = response_hash["cost_in_pence"]
      self.new_balance_in_pence = response_hash["new_balance_in_pence"]
    end

  end
end
