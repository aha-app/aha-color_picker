console.log('hello');

const $ = require('jquery');
window.$ = $;

require('./demo.css');
require('vendor/assets/javascripts/jquery.minicolors');
require('vendor/assets/stylesheets/jquery.minicolors.css');
require('javascripts/aha/color_picker.js.coffee');
require('stylesheets/aha/color_picker.css.less');

$('.color-picker').colorPicker({
  customColors: '000000,ffffff'
});
