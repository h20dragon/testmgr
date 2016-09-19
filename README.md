# Testmgr

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/testmgr`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'testmgr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install testmgr

## Usage

Testmgr::TestReport.instance.setDescription("My Example")
Testmgr::TestReport.instance.getReq('New Req').get_child('Login').add(true, "This is a passing assertion")
Testmgr::TestReport.instance.getReq('New Req').get_child('Login').add(false, "This is a failed assertion")
Testmgr::TestReport.instance.getReq('New Req').get_child('Login').add(nil, "This is a skipped assertion")

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Run unit tests

Run the unit tests:

    $ bundle exec rake spec
    
    to run a single spec,
    
    $ rspec spec/tap_sec.rb

## Build

    $ bundle exec rake build

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/testmgr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

