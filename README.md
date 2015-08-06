# ZenSend Ruby bindings 

## Installation

You don't need this source code unless you want to modify the gem. If
you just want to use the ZenSend Ruby bindings, you should run:

    gem install zensend

If you want to build the gem from source:

    bundle exec rake build

## Requirements

* Ruby 1.9.3 or above.

## Development

Test cases can be run with: `bundle exec rake spec`

## Manual Testing

    irb -I ./lib
    irb(main):001:0> require 'zensend'
    irb(main):003:0> client = ZenSend::Client.new("api_key", {}, "http://localhost:8084")
    irb(main):007:0> client.lookup_operator("441234567890")
    => #<struct ZenSend::OperatorLookupResponse mnc="34", mcc="234", operator="eeora-uk", new_balance_in_pence=184.006, cost_in_pence=2.0>

