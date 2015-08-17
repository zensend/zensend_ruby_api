[![Build Status](https://travis-ci.org/zensend/zensend_ruby_api.svg?branch=master)](https://travis-ci.org/zensend/zensend_ruby_api)
# ZenSend Ruby bindings 

## Installation

You don't need this source code unless you want to modify the gem. If
you just want to use the ZenSend Ruby bindings, you should run:

```ruby
gem install zensend
```

If you want to build the gem from source:

```ruby
bundle exec rake build
```

## Requirements

* Ruby 1.9.3 or above.

## Development

Test cases can be run with: `bundle exec rake spec`

## Manual Testing

```ruby
irb -I ./lib
irb(main):001:0> require 'zensend'
irb(main):003:0> client = ZenSend::Client.new("api_key", {}, "http://localhost:8084")
irb(main):007:0> client.lookup_operator("441234567890")
=> #<struct ZenSend::OperatorLookupResponse mnc="34", mcc="234", operator="eeora-uk", new_balance_in_pence=184.006, cost_in_pence=2.0>
```

## Examples
First, make sure you require the gem
```ruby
require 'zensend'
```
Then, create an instance of the clien
```ruby
client = ZenSend::Client.new("YOUR API KEY")
```
You can also specify timeout options and the Zensend URL. Default timeouts are 60 seconds.
```ruby
client = ZenSend::Client.new("YOUR API KEY", {open_timeout: 30, read_timeout: 30}, "http://localhost:8084")
```

### Sending SMS
To send an SMS, you must specify the originator, body and numbers:
```ruby
sms_response = client.send_sms({
  originator: "ORIGINATOR",
  body: "Hello!",
  numbers: ["447777777777", "448888888888"]
})

puts sms_response.tx_guid # the transaction identifier
puts sms_response.numbers # the amount of numbers the message will be sent to
puts sms_response.sms_parts # the amount of parts the message will be split up into
puts sms_response.encoding # the encoding used
puts sms_response.cost_in_pence # the cost of the request
puts sms_response.new_balance_in_pence # your new balance
```

You can also specify the following optional params:

```ruby
sms_response = client.send_sms({
  originator: "ORIGINATOR",
  body: "Hello!",
  numbers: ["447777777777", "448888888888"],
  originator_type: "ALPHA", # ALPHA or MSISDN
  timetolive_in_minutes: 120,
  encoding: "GSM" # GSM or UCS2
})
```

### Checking your balance
This will return your current balance:
```ruby
puts client.check_balance.inspect
```

### Listing prices
This will return a JSON string with all our prices by country code:
```ruby
puts client.get_prices
```

### Operator Lookup
This allows you to lookup the operator of a given MSISDN
```ruby
operator_lookup_response = client.lookup_operator("4477777777777")
puts operator_lookup_response.mnc
puts operator_lookup_response.mcc
puts operator_lookup_response.operator
puts operator_lookup_response.new_balance_in_pence
puts operator_lookup_response.cost_in_pence
```
