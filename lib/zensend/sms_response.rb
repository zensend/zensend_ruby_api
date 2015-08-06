module ZenSend
  SmsResponse = Struct.new(:tx_guid, :numbers, :sms_parts, :encoding, :cost_in_pence, :new_balance_in_pence)

  class SmsResponse

    def set_from_response(response_hash)
      self.tx_guid = response_hash["txguid"]
      self.numbers = response_hash["numbers"]
      self.sms_parts = response_hash["smsparts"]
      self.encoding = response_hash["encoding"]
      self.cost_in_pence = response_hash["cost_in_pence"]
      self.new_balance_in_pence = response_hash["new_balance_in_pence"]
    end

  end
end
