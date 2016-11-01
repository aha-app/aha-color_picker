# Aha::ColorPicker

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/aha/color_picker`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aha-color_picker'
```

Add to your application js/css manifests:

```js
//= require aha/color_picker
//= require jquery.minicolors
```

```css
/*
 *= require aha/color_picker
 *= require jquery.minicolors
 */
```

## Usage

Attach it to a clickable element using jQuery:

```javascript
$('button.picker').colorPicker();
```

Options:

* **customColors**: string or array of custom colors to show below the main picker

```javascript
$('button.picker').colorPicker({customColors: '000000,ffffff'});
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/aha-color_picker.

