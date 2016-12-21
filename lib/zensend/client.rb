require 'json'
require 'net/http'

module ZenSend


  class Client

    ZENSEND_URL = "https://api.zensend.io"
    VERIFY_URL = "https://verify.zensend.io"

    attr_accessor :api_key, :url, :http_opts

    def initialize(api_key, http_opts = {open_timeout: 60, read_timeout: 60}, url = ZENSEND_URL, verify_url = VERIFY_URL)
      @api_key = api_key
      @url = url
      @http_opts = http_opts
      @verify_url = verify_url
    end

    VERIFY_OPTIONS = [:message, :originator]

    def create_msisdn_verification(msisdn, verify_options = {})
      params = {}
      params["NUMBER"] = msisdn
      add_optional_param(params, verify_options, "MESSAGE", :message)
      add_optional_param(params, verify_options, "ORIGINATOR", :originator)

      verify_options.keys.each do |key|
        raise ArgumentError.new("unknown option: #{key}") if !VERIFY_OPTIONS.include?(key)
      end

      result = make_request("/api/msisdn_verify", :post, params, @verify_url)

      result["session"]
    end

    def msisdn_verification_status(session)
      params = {"SESSION" => session}
      json = make_request("/api/msisdn_verify?" + URI.encode_www_form(params), :get, nil, @verify_url)
      json["msisdn"]
    end



    ##
    # Sends an sms message
    #
    # Named paramters:
    #  originator: the originator to send from
    #  body: the body of the sms message
    #  numbers: an array of numbers to send to. they must not contain the ',' character
    #  originator_type: :alpha or :msisdn (not required)
    #  timetolive_in_minutes: number of minutes before message expires (not required)
    #  encoding: :ucs2 or :gsm (not required defaults to automatic)
    #
    # A ZenSend::ZenSendException or StandardError or ArgumentError can be raised by this
    # method. StandardError is raised by net/http. It may be one of the following subclasses:
    # [Errno::ETIMEDOUT, Errno::ECONNRESET, Errno::EHOSTUNREACH, SocketError, Net::ReadTimeout, Net::OpenTimeout]
    # This list is not exhaustive.
    #
    # An ArgumentError can be raised if any of the numbers includes a ',' character or
    # a required parameter is not specified or an unknown parameter is specified.
    #
    VALID_OPTIONS = [:originator, :body, :numbers, :originator_type, :timetolive_in_minutes, :encoding]

    def send_sms(options)

      originator = required_param(options, :originator)
      body = required_param(options, :body)
      numbers = required_param(options, :numbers)

      raise ArgumentError.new("invalid character in numbers") if numbers.any? {|x| x.include?(",")}


      options.keys.each do |key|
        raise ArgumentError.new("unknown option: #{key}") if !VALID_OPTIONS.include?(key)
      end

      sms_response = SmsResponse.new

      params = {"ORIGINATOR" => originator, "BODY" => body, "NUMBERS" => numbers.join(",")}

      add_optional_param(params, options, "ORIGINATOR_TYPE", :originator_type)
      add_optional_param(params, options, "TIMETOLIVE", :timetolive_in_minutes)
      add_optional_param(params, options, "ENCODING", :encoding)



      sms_response.set_from_response(make_request("/v3/sendsms", :post, params))

      sms_response
    end

    VALID_KEYWORD_OPTIONS = [:shortcode, :keyword, :is_sticky, :mo_url]

    def create_keyword(options)
      shortcode = required_param(options, :shortcode)
      keyword = required_param(options, :keyword)

      options.keys.each do |key|
        raise ArgumentError.new("unknown option: #{key}") if !VALID_KEYWORD_OPTIONS.include?(key)
      end

      params = {"SHORTCODE" => shortcode, "KEYWORD" => keyword}

      add_optional_param(params, options, "IS_STICKY", :is_sticky)   
      add_optional_param(params, options, "MO_URL", :mo_url)

      create_keyword_response = CreateKeywordResponse.new
      create_keyword_response.set_from_response(make_request("/v3/keywords", :post, params))

      create_keyword_response
    end

    def check_balance
      response = make_request("/v3/checkbalance", :get)
      response["balance"]
    end

    def get_prices
      response = make_request("/v3/prices", :get)
      response["prices_in_pence"]
    end

    def lookup_operator(msisdn)
      operator_lookup_response = OperatorLookupResponse.new
      operator_lookup_response.set_from_response(make_request("/v3/operator_lookup?" + URI.encode_www_form({"NUMBER" => msisdn}), :get))
      operator_lookup_response
    end

    def create_sub_account(name)
      created_sub_account_response = SubAccountCreationResponse.new
      response = make_request("/v3/sub_accounts", :post, {"NAME" => name})
      created_sub_account_response.set_from_response(response)
      created_sub_account_response
    end

    private

    def add_optional_param(params, options, name, key)
      params[name] = options[key] if options.include?(key)
    end

    def required_param(options, param)
      raise ArgumentError.new("missing: #{param}") if !options.include?(param)
      options[param]
    end

    def make_request(path, method, params = {}, base_url = nil)

      base_url = base_url || @url
      uri = URI("#{base_url}#{path}")

      response = Net::HTTP.start(uri.hostname, uri.port, @http_opts.merge(:use_ssl => uri.scheme == "https")) {|http|

        request = Net::HTTP::Post.new(uri.request_uri) if method == :post
        request = Net::HTTP::Get.new(uri.request_uri) if method == :get

        request['X-API-KEY'] = @api_key

        request.set_form_data(params) if method == :post && params

        http.request(request)
      }

      if !response.content_type.nil? && response.content_type.include?("application/json")
        json_response = JSON.parse(response.body)
        if json_response['success']
          return json_response['success']
        elsif json_response['failure']
          failure = json_response['failure']
          raise ZenSendException.new(response.code, failure["failcode"], failure["parameter"], failure["cost_in_pence"], failure["new_balance_in_pence"])
        else
          raise ZenSendException.new(response.code, nil, nil, nil, nil)
        end
      else
        raise ZenSendException.new(response.code, nil, nil, nil, nil)
      end
    end
  end
end
