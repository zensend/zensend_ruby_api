module ZenSend
  SubAccountCreationResponse = Struct.new(:name, :api_key)

  class SubAccountCreationResponse

    def set_from_response(response_hash)
      self.name = response_hash["name"]
      self.api_key = response_hash["api_key"]
    end

  end
end
