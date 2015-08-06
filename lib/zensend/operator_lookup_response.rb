module ZenSend
  OperatorLookupResponse = Struct.new(:mnc, :mcc, :operator, :new_balance_in_pence, :cost_in_pence)

  class OperatorLookupResponse

    def set_from_response(response_hash)
      self.mnc = response_hash["mnc"]
      self.mcc = response_hash["mcc"]
      self.operator = response_hash["operator"]
      self.new_balance_in_pence = response_hash["new_balance_in_pence"]
      self.cost_in_pence = response_hash["cost_in_pence"]
    end

  end
end
