**WARNING**

This is still **WIP**. Using this tool will change your local master branch
and under certain circumstances some of your feature branches too!

Use at your own risk!

# OctoMerge

`octo_merge` is a simple command line tool to merge GitHub pull requests using different strategies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'octo_merge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install octo_merge

## Examples

```
# Within your shell

octo-merge \
  --repo=rails/rails \
  --dir=~/Dev/Rails/rails \
  --pull_requests=23,42 \
  --login=Deradon \
  --password=<your-github-API-token> \
  --strategy=MergeWithRebase
```

* You can find you API token [here](https://github.com/settings/tokens)

## Available Strategies

### MergeWithoutRebase

```ruby
git.checkout(master)
git.fetch(upstream)
git.reset_hard("#{upstream}/#{master}")

pull_requests.each do |pull_request|
  git.remote_add("#{pull_request.remote} #{pull_request.remote_url}")
  git.fetch(pull_request.remote)
  git.merge_no_ff("#{pull_request.remote}/#{pull_request.branch}")
end
```

### MergeWithRebase

```ruby
git.checkout(master)
git.fetch(upstream)
git.reset_hard("#{upstream}/#{master}")

pull_requests.each do |pull_request|
  git.remote_add("#{pull_request.remote} #{pull_request.remote_url}")
  git.fetch(pull_request.remote)
  git.checkout(pull_request.branch)
  git.rebase(master)
  git.checkout(master)
  git.merge_no_ff(pull_request.branch)
end
```

### Rebase

```ruby
git.checkout(master)
git.fetch(upstream)
git.reset_hard("#{upstream}/#{master}")

pull_requests.each do |pull_request|
  git.remote_add("#{pull_request.remote} #{pull_request.remote_url}")
  git.fetch(pull_request.remote)
  git.checkout(pull_request.branch)
  git.rebase(master)
  git.checkout(master)
  git.rebase("#{pull_request.branch}")
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Deradon/octo_merge. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

