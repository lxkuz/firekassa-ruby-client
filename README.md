# Firekassa

Ruby Client of Firekassa API

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add firekassa

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install firekassa

## Usage

### Configure

When you get your Site approved you can use it's secret key for making API requests.

```ruby
  require 'firekassa'

  Firekassa.configure do |config|
    config.base_url = "<BASE API URL>" # "https://admin.vanilapay.com"
    config.api_token = "<YOUR SITE SECRET KEY>"
  end
```
Now you can make API calls

### Balance

#### To get yoour account balance:
```ruby
  Firekassa::Balance.new.get # => { "balance": "2000.0" }
```

### Account

#### To list your Site accounts:
```ruby
  Firekassa::Account.new.list # => items: [ ... ]
```
See more info in tests

#### To show your concrete account info:
```ruby
  Firekassa::Balance.new.show(account_id) # => { account_data... }
```
See more info in tests

### Transactions

#### To list transactions:
```ruby
  Firekassa::Transaction.new.list # => {items:[ trxs...] }
```
See more info in tests

#### To create deposit type:card:
```ruby
  deposit_data = {
    order_id: "123", # payment ID from your system
    amount: "5000.0",
    # callbacks
    notification_url: "http://some.url/callback",
    success_url: "http://some.url/callback",
    fail_url: "http://some.url/callback",
  }
  result = Firekassa::Deposit.new.create_card(deposit_data)
  # it responds card credentials for making payment
```
See more info in tests

#### To create withdrawal type:card:
```ruby
  # for card
  withdraw_data = {
    order_id: "123123", # payment ID from your system
    account: "4242424242424242",
    site_account: 'sber',
    amount: "100.00",
    # callbacks
    notification_url: "http://some.url/callback",
  }
  Firekassa::Withdraw.new.create_card(withdraw_data) # => { trx data... }
```
See more info in tests

#### To show transaction data:
```ruby
  Firekassa::Transaction.new.show(deposit_id) # => { trx data... }
```
See more info in tests

#### Cancel transaction:
```ruby
  Firekassa::Transaction.new.cancel(id) # => { trx data... }
```
See more info in tests


#### To download transaction receipt:
```ruby
  Firekassa::Transaction.new.download_receipt(id)
```
See more info in tests

To send transaction receipt to email:
```ruby
  Firekassa::Transaction.new.send_to_email(id)
```
See more info in tests

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lxkuz/firekassa-ruby-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/lxkuz/firekassa-ruby-client/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Firekassa project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lxkuz/firekassa-ruby-client/blob/main/CODE_OF_CONDUCT.md).
