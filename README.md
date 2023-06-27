# Rfaker

Rfaker is a gem that will allow the conditional or weighted random selection of Faker generators.

At this point it is unreleased and contains only a class for holding a tree structure of the environment Faker installation's directories, classes and methods, along with some helper methods.

## Installation

This gem is unreleased. When it is released:

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rfaker

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install rfaker

## Usage

### Compositors
Spawn a compositor with `short_form = Rfaker.composite(domain1, domain2)` or `long_form = Rfaker::Compositor.new([domain1, domain2], [weight1, weight2] | "weight description")`

Use it to generate a random return with `even_faker_faker.fake`

Valid domains are Faker generators or their superclasses up to the top of the Faker namespace itself. Only generators with arities of -1 or 0 are returned (no arguments are passed to randomly selected generators).

### Helpers
`Rfaker::Faker_tree.new(faker_classes_path)` will generate a hash accessible with `.tree` that represents the local Faker directory, class and method structure. Future version will allow multiple paths.

`Rfaker::Helpers.faker_path`, `Rfaker::Helpers.faker_class_path(faker_base_path)` and `Rfaker::Helpers.faker_yaml_path` can be used to return various local Faker paths.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

RBS and Rspec are used for testing, check in `sig` and `spec`.

## Contributing

This gem is in very early development. Feedback and PRs will be accepted after the first release.
